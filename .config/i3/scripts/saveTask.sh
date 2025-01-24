#!/bin/bash

FILE="$HOME/Documents/secondBrain/task_inbox.md"

USER_INPUT=$(rofi -dmenu -p "Enter text to prepend:")

if [ -z "$USER_INPUT" ]; then
    echo "No input provided. Exiting."
    exit 0
fi

echo -e " - [ ] $USER_INPUT\n$(cat "$FILE")" > "$FILE"

