#!/usr/bin/env bash

cd "$HOME/dotfiles" || exit

if git rev-parse --git-dir > /dev/null 2>&1; then
    # branch=$(git branch --show-current)
	text=""
    if [[ -n $(git status -s) ]]; then
        text+="*"
		class="changes"
    else
        class="clean"
    fi

    if git rev-parse --abbrev-ref @{u} > /dev/null 2>&1; then
        behind=$(git rev-list --count HEAD..@{u} 2>/dev/null)
        ahead=$(git rev-list --count @{u}..HEAD 2>/dev/null)

        if [[ $behind -gt 0 ]]; then
            text+=" $behind"
			class="dirty"
        fi
        if [[ $ahead -gt 0 ]]; then
            text+=" $ahead"
			class="dirty"
        fi
    fi

    echo "{\"text\":\"$text\", \"class\":\"$class\"}"
else
    echo "{\"text\":\"\", \"class\":\"no-repo\"}"
fi
