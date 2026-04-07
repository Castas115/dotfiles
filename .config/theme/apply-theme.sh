#!/usr/bin/env bash
# Omarchy-style theme switcher
# Usage: apply-theme.sh [dark|light|toggle]

THEME_DIR="$HOME/.config/theme"
STATE_FILE="$THEME_DIR/current"
TEMPLATES="$THEME_DIR/templates"
OUT="$THEME_DIR/generated"

# --- Determine target theme ---
CURRENT=$(cat "$STATE_FILE" 2>/dev/null || echo "dark")
case "${1:-toggle}" in
    dark|light) TARGET="$1" ;;
    toggle)     [ "$CURRENT" = "dark" ] && TARGET="light" || TARGET="dark" ;;
    *)          echo "Usage: $0 [dark|light|toggle]"; exit 1 ;;
esac

[ "$CURRENT" = "$TARGET" ] && exit 0

# --- Parse colors TOML into associative array ---
declare -A C
while IFS= read -r line; do
    [[ "$line" =~ ^[[:space:]]*#|^[[:space:]]*$ ]] && continue
    if [[ "$line" =~ ^([a-z_0-9]+)[[:space:]]*=[[:space:]]*\"([^\"]+)\" ]]; then
        C["${BASH_REMATCH[1]}"]="${BASH_REMATCH[2]}"
    fi
done < "$THEME_DIR/$TARGET.toml"

# --- Template substitution ---
apply_template() {
    local input="$1" output="$2"
    local sed_args=()
    for key in "${!C[@]}"; do
        local val="${C[$key]}"
        local val_strip="${val#\#}"
        sed_args+=(-e "s|{{${key}}}|${val}|g")
        sed_args+=(-e "s|{{${key}_strip}}|${val_strip}|g")
    done
    sed "${sed_args[@]}" "$input" > "$output"
}

# --- Generate configs ---
mkdir -p "$OUT"

# Written directly to app config paths (gitignored) — enables live reload
apply_template "$TEMPLATES/ghostty.conf.tpl"     "$HOME/.config/ghostty/config"
apply_template "$TEMPLATES/waybar.css.tpl"       "$HOME/.config/waybar/style.css"

# Written to theme/generated/ — apps source/import from here
apply_template "$TEMPLATES/tmux-theme.conf.tpl"  "$OUT/tmux.conf"
apply_template "$TEMPLATES/wofi-style.css.tpl"   "$OUT/wofi.css"
apply_template "$TEMPLATES/lualine-theme.lua.tpl" "$OUT/lualine.lua"

# --- Update state ---
echo "$TARGET" > "$STATE_FILE"

# --- Reload running applications ---

# Ghostty: trigger reload via D-Bus GTK Action
GHOSTTY_BUS=$(busctl --user list 2>/dev/null | grep -i ghostty | awk '{print $1}')
if [ -n "$GHOSTTY_BUS" ]; then
    busctl --user call "$GHOSTTY_BUS" /com/mitchellh/ghostty org.gtk.Actions \
        Activate "sava{sv}" "reload-config" 0 0 2>/dev/null || true
fi

# Neovim — switch all running instances
for sock in /run/user/$(id -u)/nvim.*.0; do
    [ -S "$sock" ] && nvim --server "$sock" --remote-send "<Cmd>colorscheme catppuccin-${C[flavour]} | lua require('lualine').setup({options={theme=loadfile(vim.fn.expand('~/.config/theme/generated/lualine.lua'))()}})<CR>" 2>/dev/null &
done

# Hyprland background color
hyprctl keyword misc:background_color "rgb(${C[background]#\#})" &>/dev/null || true

# GTK apps (Vivaldi, GNOME apps, etc.)
gsettings set org.gnome.desktop.interface color-scheme "prefer-${C[mode]}" 2>/dev/null || true
gsettings set org.gnome.desktop.interface gtk-theme "Adwaita$([ "${C[mode]}" = "dark" ] && echo "-dark" || echo "")" 2>/dev/null || true
mkdir -p "$HOME/.config/gtk-3.0"
cat > "$HOME/.config/gtk-3.0/settings.ini" <<GTKEOF
[Settings]
gtk-application-prefer-dark-theme=$([ "${C[mode]}" = "dark" ] && echo "1" || echo "0")
gtk-theme-name=Adwaita$([ "${C[mode]}" = "dark" ] && echo "-dark" || echo "")
GTKEOF

# Waybar: SIGUSR2 reloads CSS
pkill -SIGUSR2 waybar 2>/dev/null || true

# Tmux: source new theme vars, then re-run catppuccin plugin to regenerate format strings
if tmux list-sessions &>/dev/null 2>&1; then
    tmux source-file "$HOME/.config/theme/generated/tmux.conf" \; \
         run-shell "$HOME/.config/tmux/plugins/catppuccin-tmux/catppuccin.tmux" &
fi

wait 2>/dev/null
notify-send -t 2000 "Theme" "Switched to ${TARGET} mode"
