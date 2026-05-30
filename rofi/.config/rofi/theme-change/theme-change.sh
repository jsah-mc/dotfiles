#!/usr/bin/env bash

# This is a script to change themes/colors of several programs.

set -o pipefail

theme_script="$HOME/.config/hypr/scripts/theme"
config="$HOME/.config/rofi/theme-change/config.rasi"

notify_error() {
    local message="$1"

    printf 'Theme selector: %s\n' "$message" >&2
    if command -v notify-send >/dev/null 2>&1; then
        notify-send "Theme selector" "$message"
    fi
}

if [[ ! -x "$theme_script" ]]; then
    notify_error "Theme script is missing or not executable: $theme_script"
    exit 1
fi

if [[ ! -f "$config" ]]; then
    notify_error "Rofi config is missing: $config"
    exit 1
fi

mapfile -t themes < <("$theme_script" --list)

if ((${#themes[@]} == 0)); then
    notify_error "No themes were returned by $theme_script --list"
    exit 1
fi

# Get list from theme script. It already includes 'matugen' if available.
theme=$(printf '%s\n' "${themes[@]}" | rofi -dmenu -only-match -no-custom -i -p "Choose theme:" -config "$config")
rofi_status=$?

if ((rofi_status != 0)); then
    exit
fi

for available_theme in "${themes[@]}"; do
    if [[ "$theme" == "$available_theme" ]]; then
        if ! "$theme_script" "$theme"; then
            notify_error "Failed to apply theme: $theme"
            exit 1
        fi
        exit 0
    fi
done

notify_error "Invalid theme selected: $theme"
exit 1
