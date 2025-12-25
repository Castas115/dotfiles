#!/bin/bash

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

  echo "Watching directory: $path"

  inotifywait -q -m -r -e CLOSE_WRITE,DELETE,CREATE,MOVE --format="git -C '$path' add . && git -C '$path' commit -m 'autocommit on change' && git -C '$path' push" "$path" --exclude '(\.git/|#|.*~$)' | sh &
}

declare -a paths=(
  "$HOME/notes"
  # "$HOME/backedupFiles"
)

echo "Press [Ctrl+C] to stop."
for dir in "${paths[@]}"; do
  auto_git_push "$dir"
done

wait

