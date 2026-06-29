#!/usr/bin/env bash

set -o pipefail

wallpaper_dir="$HOME/Pictures/wallpaper"
config="$HOME/.config/rofi/wallpaper/config.rasi"
current_wallpaper="$HOME/.cache/current_wallpaper"
current_theme="$HOME/.cache/current_theme"
theme_script="$HOME/.config/quickshell/jsah/Apperance/Scripts/theme"

find_wallpaper_dir() {
    local candidate

    for candidate in \
        "$HOME/Pictures/wallpaper" \
        "$HOME/Pictures/wallpapers"
    do
        if [[ -d "$candidate" ]]; then
            printf '%s\n' "$candidate"
            return 0
        fi
    done

    return 1
}

notify() {
    local title="$1"
    local message="$2"

    printf '%s: %s\n' "$title" "$message" >&2
    if command -v notify-send >/dev/null 2>&1; then
        notify-send "$title" "$message"
    fi
}

set_wallpaper() {
    local image="$1"

    if command -v awww >/dev/null 2>&1; then
        if awww img "$image"; then
            return 0
        fi
        if command -v awww-daemon >/dev/null 2>&1; then
            awww-daemon >/dev/null 2>&1 &
            sleep 0.2
            awww img "$image"
        else
            return 1
        fi
    elif command -v swww >/dev/null 2>&1; then
        swww img "$image"
    elif command -v feh >/dev/null 2>&1; then
        feh --bg-scale "$image"
    else
        notify "Wallpaper" "No supported wallpaper setter found"
        return 1
    fi
}

print_wallpaper_rows() {
    local wallpaper

    for wallpaper in "${wallpapers[@]}"; do
        printf '%s\0icon\x1f%s/%s\n' "$wallpaper" "$wallpaper_dir" "$wallpaper"
    done
}

if ! wallpaper_dir=$(find_wallpaper_dir); then
    notify "Wallpaper" "Directory not found: $HOME/Pictures/wallpaper or $HOME/Pictures/wallpapers"
    exit 1
fi

mapfile -t wallpapers < <(
    cd "$wallpaper_dir" || exit 1
    find -L . -path './.git' -prune -o -type f \
        \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) \
        -printf '%P\n' | sort
)

if ((${#wallpapers[@]} == 0)); then
    notify "Wallpaper" "No wallpapers found in $wallpaper_dir"
    exit 1
fi

selection=$(
    print_wallpaper_rows |
        rofi -dmenu -only-match -no-custom -i -p "Choose wallpaper:" -config "$config" -format i
)
rofi_status=$?

if ((rofi_status != 0)); then
    exit 0
fi

if [[ ! "$selection" =~ ^[0-9]+$ ]] || ((selection < 0 || selection >= ${#wallpapers[@]})); then
    notify "Wallpaper" "Invalid selection"
    exit 1
fi

wallpaper="$wallpaper_dir/${wallpapers[$selection]}"

# Always use matugen (Material You) by default
if [[ ! -x "$theme_script" ]]; then
    notify "Wallpaper" "Theme script is missing: $theme_script"
    exit 1
fi

if ! "$theme_script" "$wallpaper"; then
    notify "Wallpaper" "Failed to apply wallpaper with matugen"
    exit 1
fi

notify "Wallpaper" "Applied $(basename "$wallpaper") and regenerated material-you"
exit 0

if ! set_wallpaper "$wallpaper"; then
    notify "Wallpaper" "Failed to apply $(basename "$wallpaper")"
    exit 1
fi

mkdir -p "$(dirname "$current_wallpaper")"
printf '%s\n' "$wallpaper" > "$current_wallpaper"

if [[ -x "$theme_script" ]]; then
    if ! "$theme_script" helium-wallpaper "$wallpaper" >/dev/null 2>&1; then
        notify "Wallpaper" "Applied $(basename "$wallpaper"), but Helium theme refresh failed"
        exit 0
    fi
fi

notify "Wallpaper" "Applied $(basename "$wallpaper")"
