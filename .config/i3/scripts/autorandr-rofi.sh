#!/bin/bash

# Get the list of autorandr profiles
profiles=$(autorandr --list | grep -v "default" | awk '{print $1}')

# If no profiles are found, exit
if [ -z "$profiles" ]; then
    notify-send "No autorandr profiles found!"
    exit 1
fi

# Use rofi to let the user select a profile
selected_profile=$(echo "$profiles" | rofi -dmenu -i -p "Select autorandr profile:")

# If no profile was selected, exit
if [ -z "$selected_profile" ]; then
    exit 0
fi

# Apply the selected profile
autorandr --load "$selected_profile"

# Notify the user
if [ $? -eq 0 ]; then
    notify-send "Autorandr" "Switched to profile: $selected_profile"
else
    notify-send "Autorandr" "Failed to switch to profile: $selected_profile"
fi
