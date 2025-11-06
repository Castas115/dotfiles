if status is-interactive
    # Commands to run in interactive sessions can go here
end

set fish_greeting ""

fish_vi_key_bindings
set -g fish_cursor_insert line
set -g fish_cursor_default block

abbr l 'nu -c ls'
abbr la 'nu -c "ls -a"'
abbr ll 'nu -c "ls -al"'
abbr lt 'eza --tree --level=2 --long --icons --git'


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

atuin init fish| source
zoxide init fish --no-cmd| source

if not test -d ~/.tmux/plugins/tpm
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
end
