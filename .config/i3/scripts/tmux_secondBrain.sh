#!/bin/bash

path="$HOME/Documents/secondBrain/"
SESSION_NAME="secondBrain"
KITTY_CLASS="kitty"

git -C "$path" pull

# Check if you're already in the session
if tmux ls | grep -q "$SESSION_NAME:.*attached"; then
    # Detach from the session if attached
    tmux detach -s "$SESSION_NAME"
else
    # Attach to the session (or create it if it doesn't exist)
    kitty --class "$KITTY_CLASS" --title "$SESSION_NAME" tmux attach-session -t "$SESSION_NAME" || \
    kitty --class "$KITTY_CLASS" --title "$SESSION_NAME" tmux new-session -s "$SESSION_NAME"
fi

