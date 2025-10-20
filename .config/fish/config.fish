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

abbr sd= 'stow . -d ~/dotfiles'

#  "$HOME/.atuin/bin/env"
atuin init fish| source
zoxide init fish --no-cmd| source

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


function y
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	yazi $argv --cwd-file="$tmp"
	if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
		builtin cd -- "$cwd"
	end
	rm -f -- "$tmp"
end


# salto things
abbr po 'bash ~/programming/scripts/pricebook-options.sh'
