#!/bin/bash

current_session=$(tmux display-message -p '#S')

if [[ $current_session == _* ]]; then
    # If we're in a _session, switch back to non-prefixed version
    target_session=${current_session#_}
    if tmux has-session -t "$target_session" 2>/dev/null; then
        tmux switch-client -t "$target_session"
    else
        tmux new-session -d -s "$target_session"
        tmux switch-client -t "$target_session"
    fi
else
    # If we're in a normal session, switch to _prefixed version
    target_session="_${current_session}"
    if tmux has-session -t "$target_session" 2>/dev/null; then
        tmux switch-client -t "$target_session"
    else
        tmux new-session -d -s "$target_session"
        tmux switch-client -t "$target_session"
    fi
fi
