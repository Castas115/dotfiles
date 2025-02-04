
if status is-interactive
    # Commands to run in interactive sessions can go here
end

set fish_greeting ""

fish_vi_key_bindings
fish_vi_cursor --force-iterm
set -g fish_cursor_insert line
set -g fish_cursor_default block


abbr ll 'ls -alF'
abbr la 'ls -A'
abbr l= 'ls -CF'
abbr sd= 'stow . -d ~/dotfiles'

#  "$HOME/.atuin/bin/env"
atuin init fish| source
zoxide init fish --no-cmd| source

alias c  '__zoxide_z'
alias cf '__zoxide_zi'
alias v  'nvim'
abbr ai 'sudo apt-get install -y'
abbr g  'lazygit'
abbr gd 'lazygit -p ~/dotfiles'
abbr b  'batcat'

abbr t  'tmux'
abbr ta  'tmux attach'
abbr tl  'tmux ls'

abbr y   'yazi'

