#!/usr/bin/env bash
cd "$(tmux display-message -p -F '#{pane_current_path}')" 2>/dev/null || exit 0
git rev-parse --is-inside-work-tree &>/dev/null || exit 0

branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
text="$branch"

yellow="#f9e2af"
red="#f38ba8"
dark="#181825"
black="#000000"
light="#cdd6f4"

accent="##FF8A65"


if [[ -n $(git status -s 2>/dev/null) ]]; then
  dirty=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
  text+=" #[fg=${yellow}]*${dirty}"
fi

if git rev-parse --abbrev-ref @{u} &>/dev/null; then
  behind=$(git rev-list --count HEAD..@{u} 2>/dev/null)
  ahead=$(git rev-list --count @{u}..HEAD 2>/dev/null)
  if [[ $behind -gt 0 ]]; then
    text+=" #[fg=${red}]${behind}"
  fi
  if [[ $ahead -gt 0 ]]; then
    text+=" #[fg=${red}]${ahead}"
  fi
fi

echo "#[fg=${accent},bg=${dark},nobold,nounderscore,noitalics]█#[fg=${black},bg=${accent},nobold,nounderscore,noitalics]󰘬 #[fg=${light},bg=${dark}] ${text}#[fg=${dark},bg=${dark},nobold,nounderscore,noitalics]█"
