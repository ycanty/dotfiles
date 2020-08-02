# pyenv
eval "$(pyenv init -)"; eval "$(pyenv virtualenv-init -)" # pyenv-setup
export CFLAGS="-I$(xcrun --show-sdk-path)/usr/include" # pyenv-install-fix
