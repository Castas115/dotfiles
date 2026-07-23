#!/usr/bin/env bash
# Omarchy-style theme switcher
# Usage: apply-theme.sh [toggle|<name>]   e.g. dark, light, gruvbox, nord, dracula

THEME_DIR="$HOME/.config/theme"
STATE_FILE="$THEME_DIR/current"
TEMPLATES="$THEME_DIR/templates"
OUT="$THEME_DIR/generated"

# --- Determine target theme ---
CURRENT=$(cat "$STATE_FILE" 2>/dev/null || echo "dark")
case "${1:-toggle}" in
    toggle) [ "$CURRENT" = "dark" ] && TARGET="light" || TARGET="dark" ;;
    *)      TARGET="$1" ;;
esac

if [ ! -f "$THEME_DIR/$TARGET.toml" ]; then
    echo "Unknown theme: $TARGET"
    echo "Available: $(cd "$THEME_DIR" && ls *.toml 2>/dev/null | sed 's/\.toml$//' | tr '\n' ' ')"
    exit 1
fi

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

# --- Generate configs in parallel ---
mkdir -p "$OUT" "$HOME/.config/tmux/scripts" "$HOME/.config/gtk-3.0"

apply_template "$TEMPLATES/alacritty-colors.toml.tpl" "$OUT/alacritty-colors.toml" &
apply_template "$TEMPLATES/git_status.sh.tpl"     "$HOME/.config/tmux/scripts/git_status.sh" &
apply_template "$TEMPLATES/tmux-theme.conf.tpl"   "$OUT/tmux.conf" &
apply_template "$TEMPLATES/wofi-style.css.tpl"    "$OUT/wofi.css" &
apply_template "$TEMPLATES/lualine-theme.lua.tpl" "$OUT/lualine.lua" &
apply_template "$TEMPLATES/colorscheme.lua.tpl"   "$OUT/colorscheme.lua" &
wait
chmod +x "$HOME/.config/tmux/scripts/git_status.sh"

# --- Update state ---
echo "$TARGET" > "$STATE_FILE"

# --- Reload running applications in parallel ---

# Neovim — switch all running instances
for sock in /run/user/$(id -u)/nvim.*.0; do
    [ -S "$sock" ] && nvim --server "$sock" --remote-send "<Cmd>colorscheme ${C[nvim_colorscheme]} | lua require('lualine').setup({options={theme=loadfile(vim.fn.expand('~/.config/theme/generated/lualine.lua'))()}})<CR>" 2>/dev/null &
done

# Hyprland background color
hyprctl keyword misc:background_color "rgb(${C[background]#\#})" &>/dev/null &

# GTK apps (Vivaldi, GNOME apps, etc.)
# Only set color-scheme — setting gtk-theme in the same call triggers an extra
# portal signal that confuses Chromium's live dark-mode listener.
{
    gsettings set org.gnome.desktop.interface color-scheme "prefer-${C[mode]}" 2>/dev/null || true
    cat > "$HOME/.config/gtk-3.0/settings.ini" <<GTKEOF
[Settings]
gtk-application-prefer-dark-theme=$([ "${C[mode]}" = "dark" ] && echo "1" || echo "0")
GTKEOF
} &

# Tmux: source new theme vars, re-run catppuccin plugin to regenerate format
# strings, then re-source the main tmux.conf so the status-right appends
# (git_status, continuum, resurrect cleanup) are re-applied on top of
# catppuccin's generated status line.
if tmux list-sessions &>/dev/null 2>&1; then
    tmux source-file "$HOME/.config/theme/generated/tmux.conf" \; \
         run-shell "$HOME/.config/tmux/plugins/catppuccin-tmux/catppuccin.tmux" \; \
         source-file "$HOME/.config/tmux/tmux.conf" &
fi

# Fire-and-forget notification (don't block on it)
notify-send -t 2000 "Theme" "Switched to ${TARGET}" &

wait 2>/dev/null
