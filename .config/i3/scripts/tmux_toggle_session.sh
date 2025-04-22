#!/bin/bash

SESSION_NAME=${1}
PROJECT_PATH=${2}
GIT_PULL=${3}

# Check if the session exists and is attached
if tmux list-sessions | grep -q "$SESSION_NAME:.*attached"; then
	# Detach from the session if attached
	tmux detach -s "$SESSION_NAME"
else
	# Attach to the session
	kitty -1 --class "floating" -d "$PROJECT_PATH" tmux new-session -A -s "$SESSION_NAME"
	if [ -n "$GIT_PULL" ]; then
		git -C "$PROJECT_PATH" pull
	fi
fi

