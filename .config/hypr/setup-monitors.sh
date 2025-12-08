#!/bin/bash

if hyprctl monitors -j | jq -r '.[].description' | grep -q "LG Electronics LG ULTRAGEAR"; then
	MON1="LG Electronics LG ULTRAGEAR"
	MON2="Philips Consumer Electronics Company PHL 243V7"
elif hyprctl monitors -j | jq -r '.[].description' | grep -q "HP Inc. HP P24h G5 3CM3471MJB"; then
	MON1="HP Inc. HP P24h G5 3CM3471MJB"
	MON2="HP Inc. HP P24h G5 3CM5090R7B"
fi


if [ -n "$MON1" ]; then
	hyprctl keyword workspace "2,name:F,monitor:desc:$MON1,defaultName:F 󰈹"
	hyprctl keyword workspace "4,name:D,monitor:desc:$MON1,defaultName:D "
	hyprctl keyword workspace "name:A,monitor:desc:$MON1"
	hyprctl keyword workspace "name:E,monitor:desc:$MON1"
	hyprctl keyword workspace "name:Q,monitor:desc:$MON1"
	hyprctl keyword workspace "name:G,monitor:desc:$MON1"
	hyprctl keyword workspace "name:W,monitor:desc:$MON1"

	hyprctl dispatch moveworkspacetomonitor 2      "desc:$MON1"
	hyprctl dispatch moveworkspacetomonitor 4      "desc:$MON1"
	hyprctl dispatch moveworkspacetomonitor name:A "desc:$MON1"
	hyprctl dispatch moveworkspacetomonitor name:E "desc:$MON1"
	hyprctl dispatch moveworkspacetomonitor name:Q "desc:$MON1"
	hyprctl dispatch moveworkspacetomonitor name:G "desc:$MON1"
	hyprctl dispatch moveworkspacetomonitor name:W "desc:$MON1"

	hyprctl keyword bind "SUPER,3,focusmonitor,desc:$MON1"
	hyprctl keyword bind "SUPER ALT,3,movecurrentworkspacetomonitor,desc:$MON1"
fi

if [ -n "$MON2" ]; then
	hyprctl keyword workspace "3,name:C,monitor:desc:$MON2,defaultName:C 󰊻"
	hyprctl keyword workspace "name:V,monitor:desc:$MON2"
	hyprctl keyword workspace "name:B,monitor:desc:$MON2"
	hyprctl keyword workspace "name:R,monitor:desc:$MON2"
	hyprctl keyword workspace "name:T,monitor:desc:$MON2"

	hyprctl dispatch moveworkspacetomonitor 3      "desc:$MON2"
	hyprctl dispatch moveworkspacetomonitor name:V "desc:$MON2"
	hyprctl dispatch moveworkspacetomonitor name:B "desc:$MON2"
	hyprctl dispatch moveworkspacetomonitor name:R "desc:$MON2"
	hyprctl dispatch moveworkspacetomonitor name:T "desc:$MON2"

	hyprctl keyword bind "SUPER,4,focusmonitor,desc:$MON2"
	hyprctl keyword bind "SUPER ALT,4,movecurrentworkspacetomonitor,desc:$MON2"
fi
