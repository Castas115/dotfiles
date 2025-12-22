#!/bin/bash

# Function to monitor a directory and auto commit/push changes
auto_git_push() {
  local path="$1"

  # Check if a path is provided
  if [[ -z "$path" ]]; then
    echo "No path provided for auto_git_push."
    return 1
  fi

  # Check if the path is valid
  if [[ ! -d "$path" ]]; then
    echo "Error: '$path' is not a valid directory."
    return 1
  fi

  git -C "$path" pull

  echo "Watching directory: $path"

  inotifywait -q -m -r -e CLOSE_WRITE,DELETE,CREATE,MOVE --format="git -C '$path' add . && git -C '$path' commit -m 'autocommit on change' && git -C '$path' push" "$path" --exclude '(\.git/|#)' | sh &
}

# Define the directories you want to monitor
declare -a paths=(
  "$HOME/notes"
  "$HOME/backedupFiles"
)

# Loop through the directories and call auto_git_push for each
echo "Press [Ctrl+C] to stop."
for dir in "${paths[@]}"; do
  auto_git_push "$dir"
done

# Keep the script running
wait

