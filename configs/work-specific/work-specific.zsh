source ~/.zsh/work-plugins.zsh

test -f ~/.aws/token.sh && source ~/.aws/token.sh

export PATH="/usr/local/opt/postgresql@11/bin:$PATH"

# Required by tools that use the AWS SDK so they can load the config from ~/.aws/config
# See: https://github.com/awslabs/amazon-ecr-credential-helper/issues/63
export AWS_SDK_LOAD_CONFIG=true

function aws-docker-login() {
  local account_id
  local region
  local domain

  if [[ -z "${AWS_PROFILE}" ]]
  then
    echo "No active AWS profile" 1>&2
    return
  fi

  account_id=$(aws configure get role_arn | sed -Ee 's/^.*::([0-9]+):.*$/\1/')
  region=$(aws configure get region)
  domain="${account_id}.dkr.ecr.${region}.amazonaws.com"
  echo "Logging in to ${domain}"
  aws ecr get-login-password | docker login --username AWS --password-stdin "${domain}"
}

function aws-assume-role() {
  if [[ -z "${AWS_PROFILE}" ]]
  then
    echo "No active AWS profile" 1>&2
    return 1
  fi

  echo -n 'Enter AWS MFA code: '
  read -r mfa
  echo
  unset AWS_ACCESS_KEY_ID
  unset AWS_SECRET_ACCESS_KEY
  unset AWS_SESSION_TOKEN
  aws-assume-role-vars "${mfa}" > ~/.aws/token.json
  gojq -r '. | "export AWS_ACCESS_KEY_ID=\(.AWS_ACCESS_KEY_ID)\nexport AWS_SECRET_ACCESS_KEY=\(.AWS_SECRET_ACCESS_KEY)\nexport AWS_SESSION_TOKEN=\(.AWS_SESSION_TOKEN)"' < ~/.aws/token.json > ~/.aws/token.sh
  source ~/.aws/token.sh
}

function aws-assume-role-vars() {
  local role_arn
  local role_name
  local max_session_duration
  local mfa_serial
  local mfa=$1

  role_arn=$(aws configure get role_arn)
  role_name=$(echo "${role_arn}" | sed -Ee 's/^.*\/(.*)$/\1/')
  max_session_duration=$(aws iam get-role --role-name "${role_name}" | gojq .Role.MaxSessionDuration)
  mfa_serial=$(aws configure get mfa_serial)

  aws sts assume-role \
      --profile uam \
      --role-arn "${role_arn}" \
      --role-session-name "${AWS_PROFILE}" \
      --duration-seconds "${max_session_duration}" \
      --serial-number "${mfa_serial}" \
      --token-code "${mfa}" | \
    gojq '.Credentials | {"AWS_ACCESS_KEY_ID": .AccessKeyId, "AWS_SECRET_ACCESS_KEY": .SecretAccessKey, "AWS_SESSION_TOKEN": .SessionToken}'
}

# Outputs environment variables and their secret values fetched from AWS secretsmanager.
# Usage:
# 1) source in the current environment with: eval "$(set-test-env)"
# 2) output to a file with set-test-env > test-env.sh
function set-test-env() {
  cat <<-EOF
   BITBUCKET_USERNAME=$(aws-sm-get-yaml-value credentials-sync/bitbucket bitbucket-rd.username)
   BITBUCKET_PASSWORD=$(aws-sm-get-yaml-value credentials-sync/bitbucket bitbucket-rd.password)
   JENKINS_JIRA_ACCESS_TOKEN=$(aws-sm-get-yaml-value credentials-sync/jira svc_jira_access_token.secret)
   JENKINS_JIRA_SECRET_ACCESS_TOKEN=$(aws-sm-get-yaml-value credentials-sync/jira svc_jira_secret_access_token.secret)
   JENKINS_JIRA_CONSUMER_KEY=$(aws-sm-get-yaml-value credentials-sync/jira svc_jira_crawl_consumer_key.secret)
   JENKINS_JIRA_KEY_CERT=$(aws-sm-get-yaml-value credentials-sync/jira svc_jira_crawl_key_cert.secret)

   export BITBUCKET_USERNAME BITBUCKET_PASSWORD \
    JENKINS_JIRA_ACCESS_TOKEN JENKINS_JIRA_SECRET_ACCESS_TOKEN \
    JENKINS_JIRA_CONSUMER_KEY JENKINS_JIRA_KEY_CERT
EOF
}

# Get a secret's value from AWS secretsmanager, where the secret's value is
# a yaml.
function aws-sm-get-yaml-value() {
  local secret_id
  local secret_path
  secret_id=$1
  secret_path=$2

  aws secretsmanager get-secret-value --secret-id "${secret_id}" | jq -r .SecretString | yq -j r - "${secret_path}"
}
