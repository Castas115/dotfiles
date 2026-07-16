#!/usr/bin/env bash
trap 'tmux set -s extended-keys off' EXIT INT TERM HUP
tmux new-session -A -s scratch
