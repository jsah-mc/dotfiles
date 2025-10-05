#!/bin/bash
set -euo pipefail

clear
echo "-------------------------------------------------------------------------------"
echo "|      ░▒▓█▓▒░░▒▓███████▓▒░▒▓███████▓▒░ ░▒▓██████▓▒░▒▓████████▓▒░▒▓███████▓▒░ |"
echo "|       ░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▒░  ░▒▓█▓▒░       |"
echo "|       ░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▒░  ░▒▓█▓▒░       |"
echo "|       ░▒▓█▓▒░░▒▓██████▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▒░   ░▒▓██████▓▒░ |"
echo "|░▒▓█▓▒░░▒▓█▓▒░      ░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▒░         ░▒▓█▓▒░|"
echo "|░▒▓█▓▒░░▒▓█▓▒░      ░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▒░         ░▒▓█▓▒░|"
echo "| ░▒▓██████▓▒░░▒▓███████▓▒░░▒▓███████▓▒░ ░▒▓██████▓▒░  ░▒▓█▓▒░  ░▒▓███████▓▒░ |"
echo "|                                                                             |"
echo "|                          With Arch Linux and Love                           |"
echo "-------------------------------------------------------------------------------"
echo

# Check gum
if ! command -v gum >/dev/null 2>&1; then
    echo "⚠️  Gum not found, installing..."
    sudo pacman -S --noconfirm gum
else
    echo "✅ Gum is installed."
fi

# Ask for sudo early
gum style --border normal --padding "1 2" "You will be prompted for your sudo password (only once)."
if ! sudo -v; then
  echo "❌ sudo authentication failed."
  exit 1
fi
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Define package lists
PACMAN_PACKAGES=(
  git
  base-devel
  fakeroot
  waybar
  rofi
  ttf-jetbrainsmono-nerd
  hyprland
  hyprlock
  hypridle
  zsh
  kitty
)

YAY_PACKAGES=(
  ttf-material-symbols-variable-git
  wlogout
  matugen-bin
  
)

# Install pacman packages
install_pacman_packages() {
  for pkg in "${PACMAN_PACKAGES[@]}"; do
    gum spin --spinner points --title "Installing $pkg" -- \
      sudo pacman -S --noconfirm --needed "$pkg"
  done
}

_isInstalled() {
    package="$1"
    check="$(sudo pacman -Qs --color always "${package}" | grep "local" | grep "${package} ")"
    if [ -n "${check}" ]; then
        echo 0
        return #true
    fi
    echo 1
    return #false
}

install_yay() {
    if [[ ! $(_isInstalled "base-devel") == 0 ]]; then
        sudo pacman --noconfirm -S "base-devel"
    fi
    if [[ ! $(_isInstalled "git") == 0 ]]; then
        sudo pacman --noconfirm -S "git"
    fi
    if [ -d $HOME/Downloads/yay-bin ]; then
        rm -rf $HOME/Downloads/yay-bin
    fi
    SCRIPT=$(realpath "$0")
    temp_path=$(dirname "$SCRIPT")
    git clone https://aur.archlinux.org/yay-bin.git $HOME/Downloads/yay-bin
    cd $HOME/Downloads/yay-bin
    makepkg -si
    cd $temp_path
    echo ":: yay has been installed successfully."
}
# Install AUR packages
install_aur_packages() {
  for pkg in "${YAY_PACKAGES[@]}"; do
    gum spin --spinner points --title "Installing AUR package $pkg" -- \
      yay -S --noconfirm --needed "$pkg"
  done
}

# Run installations
install_pacman_packages
install_yay
install_aur_packages

# Stow dotfiles
git clone https://github.com/jsah-mc/dotfiles.git ~/dotfiles || true
if [ -d "$HOME/dotfiles/config" ]; then
  if gum confirm "Found ~/dotfiles/config. Use stow to symlink config folders?"; then
    cd "$HOME/dotfiles/config"
    for dir in */ ; do
      gum spin --spinner points --title "Stowing $dir" -- stow "$dir"
    done
    echo "✅ Config folders stowed."
  else
    echo "Skipping stow config."
  fi
else
  echo "No ~/dotfiles/config found, skipping stow."
fi

# Change default shell
chsh -s /usr/bin/zsh

# Reboot prompt
if gum confirm "Do you want to reboot now?"; then
  reboot
else
  echo "Reboot manually when ready."
fi

echo "🎉 All done!"

