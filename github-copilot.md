# Copilot instructions for jsah-mc/dotfiles

Purpose: concise, machine-friendly guidance for Copilot sessions working on these dotfiles.

1) Build / install / test / lint commands

- Primary installer: ./install.sh (Arch Linux only). It:
  - requests sudo, installs prerequisites with pacman, installs yay-bin from AUR if needed
  - shows interactive gum menus to pick system packages and dotfile packages
  - stows selected packages into $HOME and backs up conflicts under ~/.dotfiles-backup/YYYYMMDD-HHMMSS
  - links wallpapers and initializes theme via quickshell script

- Stow commands commonly used:
  - Adopt existing files: stow --adopt -t "$HOME" <packages...>
  - Stow a package (non-interactive): stow -d "$PWD" -t "$HOME" <package>

- AGS / Astal: AGS files live in ags/.config/ags. To install runtime packages used by AGS on Arch (manual):
  - yay -S aylurs-gtk-shell-git libastal-git libastal-io-git libastal-meta

- There is no test or lint framework or npm/yarn scripts in this repo. If adding tooling, update README and this file.

2) High-level architecture (big picture)

- This repository is organized as GNU Stow packages. Each top-level directory maps to a target path under $HOME (e.g., hypr/ -> ~/.config/hypr).
- install.sh is the single-entry bootstrapper for new systems (Arch-only). It centralizes package lists and stow package selection.
- Key package areas:
  - hypr/: Hyprland configs and modular hypr/modules/*.lua
  - quickshell/: Quickshell QML modules and scripts (theme script used at install time)
  - rofi/: launchers, theme selector, wallpaper selector scripts
  - waybar/: modules, context menus, styles
  - ags/: AGS frontend code under .config/ags (TypeScript/JS config, no build scripts present)
  - matugen/: templates for generating theme files
  - wallpapers/: canonical wallpapers directory (linked to ~/Pictures/wallpaper by installer)

3) Key conventions and repo-specific patterns

- Stow package name == top-level directory name. When adding/removing packages, update DOTFILE_PACKAGES and SYSTEM_PACKAGES arrays in install.sh.
- Conflicts are backed up before stow into ~/.dotfiles-backup/<timestamp>. Copilot edits that replace or move files should respect that flow.
- Wallpaper canonical source: wallpapers/Pictures/wallpaper. Installer creates a symlink at ~/Pictures/wallpaper.
- Theme initialization: quickshell/.config/quickshell/jsah/scripts/theme (executable; used by install.sh).
- When adopting user files into the repo, maintain the "stow --adopt" pattern and run git restore . afterwards to keep tracked files intact (see README example).
- Matugen stores template files and a config at matugen/.config/matugen/config.toml — use it when modifying theme generation.
- Hypr configuration is modularized in hypr/modules/*.lua — change modules rather than editing the top-level hyprland.conf directly when possible.

4) Files and locations Copilot should check first when making changes

- README.md, GEMINI.md — repository summaries and notes
- install.sh — authoritative installer, DOTFILE_PACKAGES and SYSTEM_PACKAGES
- hypr/modules/, quickshell/, rofi/, waybar/ — primary user-facing config code
- matugen/ — template-driven theme generation
- ags/.config/ags/ — GUI/TypeScript assets (no build scripts present)
- wallpapers/Pictures/wallpaper and theme init script path

5) AI assistant / other assistant configs found and incorporated

- No existing Copilot/Claude/Cursor/Aider/Windsurf assistant rule files were found in the repo root (.github was not present before this file). GEMINI.md notes repository purpose and was included.

6) Notes for Copilot sessions

- This is a dotfiles repo, not an application: do not add CI or language-specific build assumptions without verifying (confirm in README or project files first).
- When adding packages, update install.sh arrays and README examples.
- Preserve symlink and backup semantics used by the installer.
- If adding tests/linting, include clear scripts (npm/pnpm/Makefile) and document how to run a single test and a full suite here.

---

Recent UI fixes: quickshell/Modules/Bar/Bar.qml

- Problem observed: bar panel was centering instead of attaching to screen edges. Root cause: earlier anchors used boolean values (anchors.top: true) which are invalid and were ignored, causing the PanelWindow to default to centered placement.

- Fixes applied:
  - Anchoring/positioning: panel now computes width, height, x and y from BarConfig (barconfig.qml) and the assigned screen object so the panel attaches to the chosen edge (top/bottom/left/right) and respects margin and custom width/height.
  - Round corners: RoundCorner instances now use BarConfig.radius (or theme fallback) for implicitSize and use AppTheme.Colors.md3.background as their color so the rounded cutouts sit on the bottom edge of the bar and reveal the background correctly.

- Files changed:
  - quickshell/.config/quickshell/jsah/Modules/Bar/Bar.qml (anchors/position computation + RoundCorner tweaks)

- How to test locally:
  1. Start Quickshell (or open the QML in qmlscene) on the target screen.
  2. Ensure BarConfig.position is "top" (default) and BarConfig.radius > 0 in quickshell/.config/quickshell/jsah/Modules/Bar/barconfig.qml or via the BarSettings UI.
  3. Observe the bar clamps to the top edge; bottom corners should show rounded cutouts matching BarConfig.radius.

- Notes for future edits:
  - If changing round-corner visuals, check quickshell/.config/quickshell/jsah/Apperance/common/RoundCorner.qml — it draws the arc as a ShapePath and expects the corner color to match the background to create a visual cutout.
  - BarConfig exposes position, height, width, margin, radius; modify those to tune placement and corner size.

---

Generated and appended by a Copilot session. Review and adjust wording or placement as needed.
