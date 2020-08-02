# kubectl
alias k=kubectl # kubectl-alias
alias kc=kubectx # kubectx-alias
source "/usr/local/opt/kube-ps1/share/kube-ps1.sh" && PS1='$(kube_ps1)'$PS1 # kube-ps1

# krew
export PATH=/Users/yves/.krew/bin:${PATH} # krew

# helm
[ $commands[helm] ] && source <(helm completion zsh) # source-zsh-completion

[[ -f "${HOME}/.kube/setup-kubeconfig.sh" ]] && . "${HOME}/.kube/setup-kubeconfig.sh"
