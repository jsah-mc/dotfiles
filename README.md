# dotfiles

GNU Stow-managed dotfiles.

## Layout

Each top-level directory is a Stow package. For example:

```sh
dotfiles/
  hypr/.config/hypr
  rofi/.config/rofi
  waybar/.config/waybar
  ags/.config/ags
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
stow --adopt -t "$HOME" hypr rofi waybar ags swaync kitty tmux nvim zed gtk qt5ct qt6ct matugen Kvantum xsettingsd zsh wallpapers
git restore .
```

`--adopt` moves existing target files into the repo. `git restore .` then restores this repo's version if Stow changed tracked files during adoption.

## Packages

- `hypr`: Hyprland config and theme scripts
- `rofi`: launchers, theme selector, wallpaper selector
- `waybar`: bar config, modules, styles, context menus
- `ags`: AGS/Astal shell entrypoint
- `swaync`: notification center style
- `kitty`: terminal colors/config
- `tmux`: terminal multiplexer config
- `zed`: editor settings
- `gtk`: GTK 3 and GTK 4 theme overrides
- `qt5ct`: Qt 5 platform config via `qt5ct-kde`
- `qt6ct`: Qt 6 platform config via `qt6ct-kde`
- `matugen`: matugen config/templates
- `Kvantum`: Qt theme config
- `xsettingsd`: GTK/XSettings integration
- `zsh`: zsh shell config
- `wallpapers`: wallpapers under `~/Pictures/wallpaper`

## AGS/Astal Packages

Install packages for the AGS v2 + Astal stack on Arch:

```sh
yay -S aylurs-gtk-shell-git libastal-git libastal-io-git libastal-meta
```

## Credits
- [mylinuxforwork/wallpaper](https://github.com/mylinuxforwork/wallpaper) for wallpapers
- [cebm1nt/dotfiles](https://github.com/cebem1nt/dotfiles) for example waybar
- [anhsirk0/rofi-config](https://github.com/anhsirk0/rofi-config) for rofi
