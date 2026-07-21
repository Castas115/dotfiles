#!/usr/bin/env bash
# Panic recovery: unstick a frozen desktop without rebooting.
# Bound to SUPER SHIFT CONTROL + X.

notify() { notify-send -u critical -a "recover" "$1" "$2" 2>/dev/null; }

# 1. Kill overlay/grab tools that can freeze the screen or steal input.
#    hyprpicker holds the frozen frame, slurp draws the crosshair, hyprshot
#    is the bash wrapper (-f: it runs as bash, so -x won't match).
pkill -x hyprpicker
pkill -x slurp
pkill -x grim
pkill -f hyprshot
pkill -x wofi
pkill -x rofi

# 2. Reload Hyprland config + relayout — fixes many visual/input glitches.
hyprctl reload >/dev/null 2>&1
hyprctl dispatch forcerendererreload >/dev/null 2>&1

# 3. Restart the bar.
pkill -9 -x .waybar-wrapped
while pgrep -x .waybar-wrapped >/dev/null; do sleep 0.05; done
sleep 0.4
setsid -f waybar >/dev/null 2>&1

# 4. Restart notification daemon.
pkill -x swaync
sleep 0.2
setsid -f swaync >/dev/null 2>&1

notify "Recovered" "Reloaded config, restarted waybar + swaync"
