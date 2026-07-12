#!/usr/bin/env bash
# Wofi menu to pick a color theme. Lists every <name>.toml palette.

THEME_DIR="$HOME/.config/theme"
CURRENT=$(cat "$THEME_DIR/current" 2>/dev/null)

choice=$(cd "$THEME_DIR" && ls *.toml 2>/dev/null | sed 's/\.toml$//' \
    | wofi --dmenu -p "Theme" --style "$THEME_DIR/generated/wofi.css")

[ -n "$choice" ] && [ "$choice" != "$CURRENT" ] && "$THEME_DIR/apply-theme.sh" "$choice"
