#!/bin/bash

squash_hourly_commits() {
  local path="$1"
  local hour_ago=$(date -d "1 hour ago" +"%Y-%m-%d %H:00:00")
  
  cd "$path"
  
  # Get the hash of the commit from 1 hour ago
  local base_commit=$(git log --since="$hour_ago" --format="%H" | tail -n 1)
  
  if [[ -n "$base_commit" && $(git log --since="$hour_ago" --oneline | wc -l) -gt 1 ]]; then
    echo "Squashing commits in $path from the last hour"
    git reset --soft "$base_commit"^
    git commit -m "Hourly squash: $(date '+%Y-%m-%d %H:00')"
    git push --force-with-lease
  fi
}

squash_incomplete_hours() {
  local path="$1"
  local today=$(date +"%Y-%m-%d")
  
  cd "$path"
  
  # Get all commits from today
  local commits_today=$(git log --since="$today 00:00:00" --format="%H %ci" | head -50)
  
  if [[ -z "$commits_today" ]]; then
    return
  fi
  
  # Get the latest commit timestamp
  local latest_commit=$(echo "$commits_today" | head -n 1)
  local latest_time=$(echo "$latest_commit" | cut -d' ' -f2)
  local latest_hour=$(echo "$latest_time" | cut -d':' -f1)
  local latest_minute=$(echo "$latest_time" | cut -d':' -f2)
  
  # If latest commit is not at x:00:00, squash the hour
  if [[ "$latest_minute" != "00" ]]; then
    local hour_start="$today $latest_hour:00:00"
    local hour_end="$today $latest_hour:59:59"
    
    # Get commits in this incomplete hour
    local hour_commits=$(git log --since="$hour_start" --until="$hour_end" --oneline | wc -l)
    
    if [[ $hour_commits -gt 1 ]]; then
      echo "Squashing incomplete hour $latest_hour in $path"
      local base_commit=$(git log --since="$hour_start" --format="%H" | tail -n 1)
      git reset --soft "$base_commit"^
      git commit -m "Hourly squash: $today $latest_hour:00"
      git push --force-with-lease
    fi
  fi
}

auto_git_push() {
  local path="$1"

  if [[ -z "$path" ]]; then
    echo "No path provided for auto_git_push."
    return 1
  fi

  if [[ ! -d "$path" ]]; then
    echo "Error: '$path' is not a valid directory."
    return 1
  fi

  git -C "$path" pull

  # Squash any incomplete hours from when script was last running
  squash_incomplete_hours "$path"

  echo "Watching directory: $path"

  # Start hourly squashing in background
  (while true; do
    sleep 3600  # 1 hour
    squash_hourly_commits "$path"
  done) &

  inotifywait -q -m -r -e CLOSE_WRITE,DELETE,CREATE,MOVE --format="git -C '$path' add . && git -C '$path' commit -m 'autocommit on change' && git -C '$path' push" "$path" --exclude '(\.git/|#)' | sh &
}

declare -a paths=(
  "$HOME/notes"
  "$HOME/backedupFiles"
)

echo "Press [Ctrl+C] to stop."
for dir in "${paths[@]}"; do
  auto_git_push "$dir"
done

wait

