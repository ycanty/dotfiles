source ~/.zsh/work-plugins.zsh

# Required by tools that use the AWS SDK so they can load the config from ~/.aws/config
# See: https://github.com/awslabs/amazon-ecr-credential-helper/issues/63
export AWS_SDK_LOAD_CONFIG=true

function docker-ecr-login() {
  local account_id
  local region
  local domain
  account_id=$(aws configure get role_arn | sed -Ee 's/^.*::([0-9]+):.*$/\1/')
  region=$(aws configure get region)
  domain="${account_id}.dkr.ecr.${region}.amazonaws.com"
  echo "Logging in to ${domain}"
  aws ecr get-login-password | docker login --username AWS --password-stdin "${domain}"
}
