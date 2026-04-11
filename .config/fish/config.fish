if status is-interactive
    # Commands to run in interactive sessions can go here
end

set fish_greeting ""

fish_vi_key_bindings
set -g fish_cursor_insert line
set -g fish_cursor_default block

alias l 'eza --long --icons --git -a'
abbr lt 'eza --long --icons --git -a --tree --level=2'


alias s  'sudo'
alias c  '__zoxide_z'
alias cf '__zoxide_zi'
alias ai 'sudo apt-get install -y'
alias au 'sudo apt update && sudo apt upgrade -y'
alias ar 'sudo apt remove -y'

alias v  'nvim'
abbr g  'lazygit'
abbr gd 'lazygit -p ~/dotfiles'
abbr b  'batcat'

abbr t  'tmux'
abbr ta  'tmux attach'
abbr tl  'tmux ls'
abbr sd 'stow . -d ~/dotfiles'

abbr vpn 'sudo openvpn --config ~/.ssh/vpn/jon.ovpn'

alias cl    'claude -c'

alias k    'kubectl'
alias ka   'kubectl apply -f'
alias kc   'kubectx'
alias kns  'kubens'

# get resources
alias kg    'kubectl get'
alias kga   'kubectl get all'
abbr kgpo  'kubectl get pods'
alias kgpow 'kubectl get pods -o wide'
alias kgd   'kubectl get deployments'
alias kgs   'kubectl get services'
alias kgn   'kubectl get nodes -o wide'
alias kgns  'kubectl get namespaces'
alias kgi   'kubectl get ingress'
alias kgcm  'kubectl get configmaps'
alias kgsec 'kubectl get secrets'
alias kgpv  'kubectl get pv'
alias kgpvc 'kubectl get pvc'
alias kgev  'kubectl get events --sort-by=.lastTimestamp'
alias kgrs  'kubectl get replicasets'
alias kgss  'kubectl get statefulsets'
alias kgds  'kubectl get daemonsets'
alias kgj   'kubectl get jobs'
alias kgcj  'kubectl get cronjobs'

# describe/logs/exec
alias kd   'kubectl describe'
alias kdel 'kubectl delete'
alias kl   'kubectl logs -f'
alias ke   'kubectl exec -it'

# context/info
alias ktx  'kubectl config get-contexts'
alias ktop 'kubectl top'
alias ktopn 'kubectl top nodes'
alias ktopp 'kubectl top pods'

atuin init fish| source
zoxide init fish --no-cmd| source
kubectl completion fish | source

function mkcd
    mkdir -p $argv[1] && cd $argv[1]
end

if not test -d ~/.tmux/plugins/tpm
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
end
