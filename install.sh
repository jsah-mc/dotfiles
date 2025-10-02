#!/bin/bash

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
echo "Checking if gum is installed..."
sleep 2

if ! command -v gum >/dev/null 2>&1; then
    echo "Gum is not installed. Installing gum..."
    sleep 2
    sudo pacman -S gum --noconfirm
else
    echo "Gum is already installed. Continuing..."
    sleep 2
fi

clear
if gum confirm "Pick Yes if this is running from curl -s\nif not and you are running it locally in the folder pick no"; then
	echo "Ok continuing"
	sleep 2s
else
	echo "Aborting"
	sleep 2s
	exit 1
fi


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
echo "Checking if gum is installed"
sleep 2s

if command -v "gum" >/dev/null 2>&1; then
  echo "Gum is Installed Procedding to install"
  sleep 2s
else
  echo "Installing Gum"
  sleep 2s
  sudo pacman -S gum --noconfirm
fi

# Request sudo upfront and keep it alive
gum style --border normal --padding "1 2" "You will be prompted for your sudo password (only once)."
if ! sudo -v; then
  echo "❌ sudo authentication failed."
  exit 1
fi
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

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
echo "|                          Installing Packages                                |"
echo "-------------------------------------------------------------------------------"

# Define packages in lists
PACMAN_PACKAGES=(
  git
  base-devel
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
)

install_pacman_packages() {
  for pkg in "${PACMAN_PACKAGES[@]}"; do
    gum spin --spinner points --title "Installing $pkg" -- sudo pacman -S --noconfirm --needed "$pkg"
  done
}

install_aur_packages() {
  for pkg in "${YAY_PACKAGES[@]}"; do
    gum spin --spinner points --title "Installing AUR package $pkg with yay" -- bash -c "
      yay -S --noconfirm --needed \"$pkg\" || echo '❌ Failed to install $pkg' >&2
    "
  done
}


install_yay() {
  if command -v yay >/dev/null 2>&1; then
    echo "✅ yay is already installed. Skipping."
    return
  fi

  if ! gum confirm "Install yay (AUR helper)?"; then
    echo "Skipping yay installation."
    return
  fi

  gum spin --spinner points --title "Cloning yay from AUR and building with fakeroot" -- bash -c '
    set -e
    tmpdir="/tmp/yaybuild_$$"
    rm -rf "$tmpdir"
    git clone https://aur.archlinux.org/yay.git "$tmpdir"
    cd "$tmpdir"
    makepkg -cf
  '

  PKGFILE=$(ls /tmp/yaybuild_*/yay-*.tar.zst 2>/dev/null | head -n1 || true)

  if [[ -z "$PKGFILE" || ! -f "$PKGFILE" ]]; then
    echo "❌ Failed to find built yay package."
    exit 1
  fi

  gum spin --spinner points --title "Installing yay package (requires sudo)" -- sudo pacman -U --noconfirm "$PKGFILE"

  echo "✅ yay installed."
}

install_pacman_packages
install_yay
install_aur_packages
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
echo "|                          Installing Config                                  |"
echo "-------------------------------------------------------------------------------"


# Stow dotfiles
git clone https://github.com/jsah-mc/dotfiles.git ~/dotfiles
if [ -d "$HOME/dotfiles/config" ]; then
  if gum confirm "Found ~/dotfiles/config directory. Do you want to use stow to symlink your config folders now?"; then
    cd "$HOME/dotfiles/config"
    for dir in */ ; do
      dir=${dir%/}
      gum spin --spinner points --title "Stowing $dir" -- stow "$dir"
    done
    echo "✅ Config folders stowed successfully."
  else
    echo "Skipping stow config."
  fi
else
  echo "No ~/dotfiles/config directory found. Skipping stow step."
fi
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
echo "|                          Finising Up                                        |"
echo "-------------------------------------------------------------------------------"


chsh /usr/bin/zsh
if gum confirm "Do You Want To Reboot?"; then
	reboot
else
	echo "Reboot Manually"
	exit 0
fi

echo "🎉 All done!"

