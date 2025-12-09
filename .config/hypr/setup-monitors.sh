#!/bin/bash

get_monitor_name() {
	hyprctl monitors -j | jq -r --arg desc "$1" '.[] | select(.description == $desc) | .name'
}

if hyprctl monitors -j | jq -r '.[].description' | grep -q "LG Electronics LG ULTRAGEAR"; then
	MON1=$(get_monitor_name "LG Electronics LG ULTRAGEAR")
	MON2=$(get_monitor_name "Philips Consumer Electronics Company PHL 243V7")
elif hyprctl monitors -j | jq -r '.[].description' | grep -q "HP Inc. HP P24h G5 3CM3471MJB"; then
	MON1=$(get_monitor_name "HP Inc. HP P24h G5 3CM3471MJB")
	MON2=$(get_monitor_name "HP Inc. HP P24h G5 3CM5090R7B")
fi

if [ -n "$MON1" ]; then
	hyprctl keyword workspace "2,name:F,monitor:$MON1,defaultName:F 󰈹"
	hyprctl keyword workspace "4,name:D,monitor:$MON1,defaultName:D "
	hyprctl keyword workspace "name:A,monitor:$MON1"
	hyprctl keyword workspace "name:E,monitor:$MON1"
	hyprctl keyword workspace "name:Q,monitor:$MON1"
	hyprctl keyword workspace "name:G,monitor:$MON1"
	hyprctl keyword workspace "name:W,monitor:$MON1"

	hyprctl dispatch moveworkspacetomonitor 2      "$MON1"
	hyprctl dispatch moveworkspacetomonitor 4      "$MON1"
	hyprctl dispatch moveworkspacetomonitor name:A "$MON1"
	hyprctl dispatch moveworkspacetomonitor name:E "$MON1"
	hyprctl dispatch moveworkspacetomonitor name:Q "$MON1"
	hyprctl dispatch moveworkspacetomonitor name:G "$MON1"
	hyprctl dispatch moveworkspacetomonitor name:W "$MON1"

	hyprctl keyword bind "SUPER,3,focusmonitor,$MON1"
	hyprctl keyword bind "SUPER ALT,3,movecurrentworkspacetomonitor,$MON1"
fi

if [ -n "$MON2" ]; then
	hyprctl keyword workspace "3,name:C,monitor:$MON2,defaultName:C 󰊻"
	hyprctl keyword workspace "name:V,monitor:$MON2"
	hyprctl keyword workspace "name:B,monitor:$MON2"
	hyprctl keyword workspace "name:R,monitor:$MON2"
	hyprctl keyword workspace "name:T,monitor:$MON2"

	hyprctl dispatch moveworkspacetomonitor 3      "$MON2"
	hyprctl dispatch moveworkspacetomonitor name:V "$MON2"
	hyprctl dispatch moveworkspacetomonitor name:B "$MON2"
	hyprctl dispatch moveworkspacetomonitor name:R "$MON2"
	hyprctl dispatch moveworkspacetomonitor name:T "$MON2"

	hyprctl keyword bind "SUPER,4,focusmonitor,$MON2"
	hyprctl keyword bind "SUPER ALT,4,movecurrentworkspacetomonitor,$MON2"
fi
