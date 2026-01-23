#!/bin/bash

declare -a paths=(
  "$HOME/notes"
)

squash_hourly_commits() {
  local path="$1"
  [[ -z "$path" || ! -d "$path" ]] && return 1
  
  for i in {0..6}; do
    date_check=$(date -d "$i days ago" +%Y-%m-%d)
    for hour in {00..23}; do
      commits=$(git -C "$path" log --format="%H" --since="$date_check $hour:00:00" --until="$date_check $hour:59:59")
      [[ $(echo "$commits" | wc -l) -gt 1 ]] && {
        git -C "$path" reset --soft "$(echo "$commits" | tail -1)"
        git -C "$path" commit -m "hourly commit" && git -C "$path" push --force
      }
    done
  done
}

start_hourly_squash_timer() {
  while sleep $(($(date -d "$(date +%Y-%m-%d\ %H):00:00 + 1 hour" +%s) - $(date +%s))); do
    for dir in "${paths[@]}"; do squash_hourly_commits "$dir"; done
  done
}

auto_git_push() {
  local path="$1"
  [[ -z "$path" || ! -d "$path" ]] && return 1
  git -C "$path" pull
  echo "Watching directory: $path"
  inotifywait -q -m -r -e CLOSE_WRITE,DELETE,CREATE,MOVE --format="sleep 0.5 && git -C '$path' add . && git -C '$path' commit -m 'autocommit on change' && git -C '$path' push" "$path" --exclude '(\.git/|#|.*~$)' | sh &
}

# squash_hourly_commits "$HOME/notes"

start_hourly_squash_timer &
squash_timer_pid=$!

for dir in "${paths[@]}"; do
  auto_git_push "$dir"
done

wait
