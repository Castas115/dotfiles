#!/bin/bash

path="$HOME/Documents/secondBrain/"
SESSION_NAME="secondBrain"

# Check if the session exists and is attached
if tmux list-sessions | grep -q "$SESSION_NAME:.*attached"; then
	# Detach from the session if attached
	tmux detach -s "$SESSION_NAME"
else
	# Attach to the session
	kitty -1 --title "$SESSION_NAME" tmux attach -t "$SESSION_NAME"
	git -C "$path" pull
fi

