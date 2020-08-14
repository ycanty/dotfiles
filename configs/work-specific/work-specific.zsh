source ~/.zsh/work-plugins.zsh

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
  local role_arn
  local role_name
  local max_session_duration
  local mfa_serial
  local mfa

  if [[ -z "${AWS_PROFILE}" ]]
  then
    echo "No active AWS profile" 1>&2
    return 1
  fi

  role_arn=$(aws configure get role_arn)
  role_name=$(echo "${role_arn}" | sed -Ee 's/^.*\/(.*)$/\1/')
  max_session_duration=$(aws iam get-role --role-name "${role_name}" | gojq .Role.MaxSessionDuration)
  mfa_serial=$(aws configure get mfa_serial)
  echo -n 'Enter AWS MFA code: '
  read -r -s mfa
  echo
  aws sts assume-role \
      --profile uam \
      --role-arn "${role_arn}" \
      --role-session-name "${AWS_PROFILE}" \
      --duration-seconds "${max_session_duration}" \
      --serial-number "${mfa_serial}" \
      --token-code "${mfa}" | \
    gojq '.Credentials | {"AWS_ACCESS_KEY_ID": .AccessKeyId, "AWS_SECRET_ACCESS_KEY": .SecretAccessKey, "AWS_SESSION_TOKEN": .SessionToken}'
}
