---
name: dotfiles-stow
description: Manage personal dotfiles with GNU Stow — apply, remove, re-apply symlinks, new machine setup, add new packages.
---

# dotfiles-stow

Repo: `~/dotfiles` | Tool: GNU Stow | Primary distro: EndeavourOS (Arch) + GNOME

## Folder Structure

```
dotfiles/
├── .agents/skills/dotfiles-stow/
├── .rules/ponytail.md
├── asset/
├── bash/
│   ├── .bashrc
│   └── .config/bash/
├── atuin/
│   └── .config/atuin/
├── cava/
│   └── .config/cava/
├── fastfetch/
│   └── .config/fastfetch/
├── mpd/
│   └── .config/mpd/
├── mpDris2/
│   └── .config/mpDris2/          (systemd user service)
├── rmpc/
│   └── .config/rmpc/
├── scripts/
│   └── .config/scripts/          (wallctl, etc)
├── starship/
│   └── .config/starship.toml
├── superfile/
│   └── .config/superfile/
├── wezterm/
│   └── .config/wezterm/
│       ├── modules/              (00_core, 01_appearance, 02_events, 03_keys, 05_mouse, 06_backdrops)
│       └── utils/                (constants)
└── zsh/
    ├── .zshrc
    └── .config/zsh/              (00-env, 01-options, 02-history, 03-completion, 04-plugins, 05-aliases, 40-init, 41-keybind, 50-startup, functions/, helpers/, ui/)
```

## Packages

| Folder      | Target                         |
| ----------- | ------------------------------ |
| `bash`      | `~/.bashrc`, `~/.config/bash/` |
| `zsh`       | `~/.zshrc`, `~/.config/zsh/`   |
| `atuin`     | `~/.config/atuin/`             |
| `wezterm`   | `~/.config/wezterm/`           |
| `fastfetch` | `~/.config/fastfetch/`         |
| `starship`  | `~/.config/starship.toml`      |
| `mpd`       | `~/.config/mpd/`               |
| `mpDris2`   | `~/.config/mpDris2/`           |
| `rmpc`      | `~/.config/rmpc/`              |
| `cava`      | `~/.config/cava/`              |
| `scripts`   | `~/.config/scripts/`           |

## Commands

```bash
stow <pkg>             # apply
stow -D <pkg>          # remove
stow -R <pkg>          # re-apply
stow --simulate <pkg>  # dry run
```

Apply all:

```bash
stow bash zsh atuin wezterm fastfetch starship mpd mpDris2 rmpc cava scripts
```

## New machine setup

```bash
# Arch/EndeavourOS
sudo pacman -S stow git

# Ubuntu/Debian
sudo apt install stow git

git clone https://github.com/rimuren/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow bash zsh atuin wezterm fastfetch starship mpd mpDris2 rmpc cava scripts

# Buat folder MPD yang dibutuhkan
mkdir -p ~/.config/mpd/component ~/.config/mpd/playlists

# Aktifkan service
systemctl --user enable --now mpd
systemctl --user enable --now mpDris2

# Clone ZSH plugins manual
mkdir -p ~/.config/zsh/plugins/manual
cd ~/.config/zsh/plugins/manual
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting
git clone https://github.com/Aloxaf/fzf-tab
git clone https://github.com/rupa/z
git clone https://github.com/hlissner/zsh-autopair
git clone https://github.com/zsh-users/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-completions
```

## Add a new package

Mirror the target path under `~/dotfiles/<pkg>/`:

```
dotfiles/
└── mypkg/
    └── .config/
        └── mypkg/
            └── config.toml   -> ~/.config/mypkg/config.toml
```

Then `stow mypkg`.

## Fix conflicts

```bash
mv ~/.config/<pkg> ~/.config/<pkg>.bak
stow <pkg>
```

## Update & sync

```bash
cd ~/dotfiles
git add .
git commit -m "update: <pkg>"
git push
```
