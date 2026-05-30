# dotfiles

GNU Stow-managed dotfiles.

## Layout

Each top-level directory is a Stow package. For example:

```sh
dotfiles/
  hypr/.config/hypr
  rofi/.config/rofi
  waybar/.config/waybar
```

## Install On A Fresh System

From this directory:

```sh
./install.sh
```

The installer is Arch Linux only and has no options. It asks for sudo privileges up front, installs bootstrap tools with `pacman`, and installs `yay-bin` from the AUR if `yay` is not already available.

Interactive installs use `gum` menus to select:

- dotfile configs to stow
- system packages to install

After stowing, it initializes the theme from `~/Pictures/wallpaper/default.jpg` if that file exists. The installer backs up conflicting real files into `~/.dotfiles-backup/` before stowing.

## Adopt Existing Files

If the files already exist in `~/.config`, Stow will report conflicts. To adopt existing files into this repo:

```sh
stow --adopt -t "$HOME" hypr rofi waybar swaync kitty tmux nvim zed gtk matugen Kvantum xsettingsd zsh wallpapers
git restore .
```

`--adopt` moves existing target files into the repo. `git restore .` then restores this repo's version if Stow changed tracked files during adoption.

## Packages

- `hypr`: Hyprland config and theme scripts
- `rofi`: launchers, theme selector, wallpaper selector
- `waybar`: bar config, modules, styles, context menus
- `swaync`: notification center style
- `kitty`: terminal colors/config
- `tmux`: terminal multiplexer config
- `zed`: editor settings
- `gtk`: GTK 3 and GTK 4 theme overrides
- `matugen`: matugen config/templates
- `Kvantum`: Qt theme config
- `xsettingsd`: GTK/XSettings integration
- `zsh`: zsh shell config
- `wallpapers`: wallpapers under `~/Pictures/wallpaper`
