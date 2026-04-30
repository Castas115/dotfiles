#!/usr/bin/env bash
# Snap volume to next multiple of 10 (up or down).
# Usage: volume-snap.sh up|down

set -euo pipefail

dir=${1:?usage: $0 up|down}

read -r _ vol _ < <(wpctl get-volume @DEFAULT_AUDIO_SINK@)
cur=$(awk -v v="$vol" 'BEGIN { printf "%d", v * 100 + 0.5 }')

case "$dir" in
  up)   target=$(( (cur / 10) * 10 + 10 )) ;;
  down) target=$(( cur % 10 == 0 ? cur - 10 : (cur / 10) * 10 )) ;;
  *) echo "usage: $0 up|down" >&2; exit 1 ;;
esac

(( target < 0 )) && target=0

wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ "${target}%"
