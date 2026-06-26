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
│   └── .local/bin/               (wallctl, etc)
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
    └── .config/zsh/              (10-env, 20-path, 30-aliases, 40-prompt, 41-keybind, 50-tools, 60-completions, ...)
```

## Packages

| Folder     | Target                         |
|------------|--------------------------------|
| `bash`     | `~/.bashrc`, `~/.config/bash/` |
| `zsh`      | `~/.zshrc`, `~/.config/zsh/`   |
| `atuin`    | `~/.config/atuin/`             |
| `wezterm`  | `~/.config/wezterm/`           |
| `fastfetch`| `~/.config/fastfetch/`         |
| `starship` | `~/.config/starship.toml`      |
| `superfile`| `~/.config/superfile/`         |
| `mpd`      | `~/.config/mpd/`               |
| `mpDris2`  | `~/.config/mpDris2/`           |
| `rmpc`     | `~/.config/rmpc/`              |
| `cava`     | `~/.config/cava/`              |
| `scripts`  | `~/.local/bin/`                |

## Commands

```bash
stow <pkg>             # apply
stow -D <pkg>          # remove
stow -R <pkg>          # re-apply
stow --simulate <pkg>  # dry run
```

Apply all:
```bash
stow bash zsh atuin wezterm fastfetch starship superfile mpd mpDris2 rmpc cava scripts
```

## New machine setup

```bash
# Arch/EndeavourOS
sudo pacman -S stow git

# Ubuntu/Debian
sudo apt install stow git

git clone https://github.com/rimuren/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow bash zsh atuin wezterm fastfetch starship superfile mpd mpDris2 rmpc cava scripts
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
