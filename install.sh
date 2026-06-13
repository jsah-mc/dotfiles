#!/usr/bin/env bash
set -euo pipefail

DOTFILE_PACKAGES=(
    hypr
    rofi
    waybar
    quickshell
    swaync
    kitty
    tmux
    nvim
    zed
    ags
    gtk
    qt5ct-kde
    qt6ct-kde
    Kvantum
    xsettingsd
    zsh
    wallpapers
)

SYSTEM_PACKAGES=(
    stow
    git
    gum
    base-devel
    hyprland
    hyprlock
    hypridle
    waybar
    quickshell
    rofi
    kitty
    tmux
    neovim
    zed
    kde-material-you-colors
    python-pywal
    kvantum
    xsettingsd
    swaync
    aylurs-gtk-shell-git
    libastal-git
    libastal-io-git
    libastal-meta
    jq
    playerctl
    brightnessctl
    wl-clipboard
    dolphin
    qt6ct-kde
    qt5ct-kde
    zsh
    fzf
    zoxide
)

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
target_dir="${HOME}"
backup_dir="${HOME}/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
selected_dotfiles=()
selected_system_packages=()

log() {
    printf '%s\n' "$*"
}

die() {
    printf 'error: %s\n' "$*" >&2
    exit 1
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

require_arch() {
    command_exists pacman || die "this installer is Arch Linux only"
}

request_sudo() {
    command_exists sudo || die "sudo is required"
    log "Requesting sudo privileges"
    sudo -v
}

install_yay_bin() {
    local build_dir

    sudo pacman -S --needed --noconfirm git base-devel stow gum

    if command_exists yay; then
        log "yay is already installed"
        return 0
    fi

    log "Installing yay-bin from AUR"
    build_dir=$(mktemp -d)
    git clone https://aur.archlinux.org/yay-bin.git "$build_dir/yay-bin"
    (
        cd "$build_dir/yay-bin"
        makepkg -si --noconfirm
    )
    rm -rf "$build_dir"
}

select_system_packages() {
    local selected

    selected=$(gum choose --no-limit --height 18 --header "Select system packages to install" "${SYSTEM_PACKAGES[@]}" || true)
    if [ -z "$selected" ]; then
        selected_system_packages=()
        return 0
    fi

    mapfile -t selected_system_packages <<< "$selected"
}

select_dotfile_packages() {
    local selected

    selected=$(gum choose --no-limit --height 18 --header "Select dotfile configs to install" "${DOTFILE_PACKAGES[@]}" || true)
    [ -n "$selected" ] || die "no dotfile configs selected"

    mapfile -t selected_dotfiles <<< "$selected"
}

install_system_packages() {
    if [ "${#selected_system_packages[@]}" -eq 0 ]; then
        log "No system packages selected"
        return 0
    fi

    log "Installing system packages with yay: ${selected_system_packages[*]}"
    yay -S --needed "${selected_system_packages[@]}"
}

backup_conflicts() {
    local package=$1
    local source_path target_path relative_path

    while IFS= read -r -d '' source_path; do
        relative_path=${source_path#"${repo_dir}/${package}/"}
        target_path="${target_dir}/${relative_path}"

        if [ -L "$target_path" ]; then
            continue
        fi

        if [ -e "$target_path" ]; then
            mkdir -p "${backup_dir}/$(dirname "$relative_path")"
            log "Backing up ${target_path} -> ${backup_dir}/${relative_path}"
            mv "$target_path" "${backup_dir}/${relative_path}"
        fi
    done < <(find "${repo_dir}/${package}" -type f -not -path '*/.git/*' -print0)
}

link_wallpapers() {
    local source_path="${repo_dir}/wallpapers/Pictures/wallpaper"
    local target_path="${target_dir}/Pictures/wallpaper"

    mkdir -p "$(dirname "$target_path")"

    if [ -L "$target_path" ] && [ "$(readlink -f "$target_path")" = "$source_path" ]; then
        log "wallpapers already linked"
        return 0
    fi

    if [ -e "$target_path" ] || [ -L "$target_path" ]; then
        mkdir -p "${backup_dir}/Pictures"
        log "Backing up ${target_path} -> ${backup_dir}/Pictures/wallpaper"
        mv "$target_path" "${backup_dir}/Pictures/wallpaper"
    fi

    log "Linking ${target_path} -> ${source_path}"
    ln -s "$source_path" "$target_path"
}

stow_dotfiles() {
    local package

    for package in "${selected_dotfiles[@]}"; do
        [ -d "${repo_dir}/${package}" ] || die "unknown package: ${package}"

        log "Installing ${package}"
        if [ "$package" = "wallpapers" ]; then
            link_wallpapers
            continue
        fi

        backup_conflicts "$package"
        stow -d "$repo_dir" -t "$target_dir" "$package"
    done
}

init_theme() {
    local wallpaper="${HOME}/Pictures/wallpaper/default.jpg"
    local theme_script="${repo_dir}/quickshell/.config/quickshell/jsah/scripts/theme"

    if [ ! -f "$wallpaper" ]; then
        log "Skipping theme init: ${wallpaper} does not exist"
        return 0
    fi

    if [ ! -x "$theme_script" ]; then
        chmod +x "$theme_script" "${theme_script%/*}/update_theme.sh"
    fi

    log "Initializing theme from ${wallpaper}"
    if ! "$theme_script" material-you "$wallpaper"; then
        log "Theme init failed; continuing"
    fi
}

main() {
    [ "$#" -eq 0 ] || die "this installer has no options; run ./install.sh"

    require_arch
    request_sudo
    install_yay_bin

    select_system_packages
    install_system_packages

    select_dotfile_packages
    stow_dotfiles

    init_theme

    if [ -d "$backup_dir" ]; then
        log "Backups saved in ${backup_dir}"
    fi

    log "Done."
}

main "$@"
