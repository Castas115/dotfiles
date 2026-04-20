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
abbr ka   'k apply -f'
abbr kc   'kubectx'
abbr kns  'kubens'

# get resources
abbr kg    'k get'
abbr kga   'k get all'
abbr kgpo  'k get pods'
abbr kgpow 'k get pods -o wide'
abbr kgd   'k get deployments'
abbr kgs   'k get services'
abbr kgn   'k get nodes -o wide'
abbr kgns  'k get namespaces'
abbr kgi   'k get ingress'
abbr kgcm  'k get configmaps'
abbr kgsec 'k get secrets'
abbr kgev  'k get events --sort-by=.lastTimestamp'
abbr kgrs  'k get replicasets'
abbr kgss  'k get statefulsets'
abbr kgds  'k get daemonsets'
abbr kgj   'k get jobs'
abbr kgcj  'k get cronjobs'

# describe/logs/exec
abbr kd   'k describe'
abbr kdel 'k delete'
abbr kl   'k logs -f'
abbr ke   'k exec -it'

# context/info
abbr ktx  'k config get-contexts'
abbr ktop 'k top'
abbr ktopn 'k top nodes'
abbr ktopp 'k top pods'

complete -c k -w kubectl
kubectl completion fish | source

atuin init fish| source
zoxide init fish --no-cmd| source

function mkcd
    mkdir -p $argv[1] && cd $argv[1]
end

if not test -d ~/.tmux/plugins/tpm
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
end
