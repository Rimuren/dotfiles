#!/usr/bin/env bash
# install.sh — bootstrap apps dari dotfiles ini
# Distro yang didukung: Arch/EndeavourOS, Fedora, Linux Mint, Alpine

set -euo pipefail

# ─── Deteksi distro ───────────────────────────────────────────────
detect_distro() {
  if [[ -f /etc/os-release ]]; then
    . /etc/os-release
    echo "${ID}"
  else
    echo "unknown"
  fi
}

DISTRO=$(detect_distro)

case "$DISTRO" in
  arch|endeavouros|manjaro) FAMILY="arch" ;;
  fedora)                   FAMILY="fedora" ;;
  linuxmint|ubuntu|debian)  FAMILY="debian" ;;
  alpine)                   FAMILY="alpine" ;;
  *)
    echo "Distro '$DISTRO' belum didukung."
    echo "Install manual — lihat appList.md"
    exit 1
    ;;
esac

echo "Distro terdeteksi: $DISTRO ($FAMILY)"

# ─── Package manager helpers ──────────────────────────────────────
pkg_install() {
  case "$FAMILY" in
    arch)   sudo pacman -S --needed --noconfirm "$@" ;;
    fedora) sudo dnf install -y "$@" ;;
    debian) sudo apt install -y "$@" ;;
    alpine) sudo apk add "$@" ;;
  esac
}

pkg_update() {
  case "$FAMILY" in
    arch)   sudo pacman -Syu --noconfirm ;;
    fedora) sudo dnf upgrade -y ;;
    debian) sudo apt update && sudo apt upgrade -y ;;
    alpine) sudo apk update && sudo apk upgrade ;;
  esac
}

# ─── AUR helper (Arch only) ───────────────────────────────────────
aur_install() {
  if command -v yay &>/dev/null; then
    yay -S --needed --noconfirm "$@"
  elif command -v paru &>/dev/null; then
    paru -S --needed --noconfirm "$@"
  else
    echo "AUR helper tidak ditemukan, skip: $*"
    echo "Install yay/paru lalu jalankan: yay -S $*"
  fi
}

# ─── Update dulu ─────────────────────────────────────────────────
echo ""
echo "==> Update package list..."
pkg_update

# ─── Core tools ──────────────────────────────────────────────────
echo ""
echo "==> Install core tools..."

case "$FAMILY" in
  arch)
    pkg_install \
      zsh bash git stow \
      wezterm \
      starship \
      atuin \
      micro \
      fzf eza fd bat chafa xclip xdg-utils \
      nmap \
      fastfetch \
      bluez bluez-utils \
      mpd mpc \
      cava \
      pipewire pipewire-pulse wireplumber \
      poppler
    ;;
  fedora)
    pkg_install \
      zsh bash git stow \
      micro \
      fzf fd-find bat chafa xclip xdg-utils \
      nmap \
      fastfetch \
      bluez \
      mpd mpc \
      cava \
      pipewire pipewire-pulse wireplumber \
      poppler-utils
    ;;
  debian)
    pkg_install \
      zsh bash git stow \
      micro \
      fzf fd-find bat chafa xclip xdg-utils \
      nmap \
      bluez \
      mpd mpc \
      cava \
      pipewire pipewire-pulse wireplumber \
      poppler-utils
    ;;
  alpine)
    pkg_install \
      zsh bash git stow \
      micro \
      fzf fd bat chafa xclip xdg-utils \
      nmap \
      bluez \
      mpd mpc \
      cava \
      pipewire pipewire-pulse wireplumber \
      poppler
    ;;
esac

# ─── eza (tidak semua repo punya) ────────────────────────────────
echo ""
echo "==> Install eza..."
case "$FAMILY" in
  arch)   pkg_install eza ;;
  fedora) pkg_install eza || echo "eza tidak ada di repo Fedora, coba: cargo install eza" ;;
  debian)
    if ! command -v eza &>/dev/null; then
      # Install via official release binary
      EZA_URL=$(curl -s https://api.github.com/repos/eza-community/eza/releases/latest \
        | grep "browser_download_url.*eza_x86_64-unknown-linux-gnu.tar.gz" \
        | cut -d '"' -f 4)
      if [[ -n "$EZA_URL" ]]; then
        curl -Lo /tmp/eza.tar.gz "$EZA_URL"
        tar -xzf /tmp/eza.tar.gz -C /tmp
        sudo mv /tmp/eza /usr/local/bin/eza
        rm /tmp/eza.tar.gz
        echo "eza berhasil diinstall."
      else
        echo "Gagal fetch eza release, install manual."
      fi
    else
      echo "eza sudah terinstall."
    fi
    ;;
  alpine) pkg_install eza || echo "eza tidak ada di Alpine repo, coba: cargo install eza" ;;
esac

# ─── wezterm (non-Arch) ───────────────────────────────────────────
echo ""
echo "==> Install wezterm..."
case "$FAMILY" in
  arch) ;; # sudah diinstall di atas
  fedora)
    if ! command -v wezterm &>/dev/null; then
      sudo dnf copr enable wezfurlong/wezterm-nightly -y && pkg_install wezterm \
        || echo "Gagal install wezterm via copr. Download manual: https://wezfurlong.org/wezterm/installation.html"
    fi
    ;;
  debian)
    if ! command -v wezterm &>/dev/null; then
      curl -fsSL https://apt.fury.io/wezfurlong/gpg.key \
        | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
      echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wezfurlong/ * *' \
        | sudo tee /etc/apt/sources.list.d/wezterm.list
      sudo apt update && pkg_install wezterm \
        || echo "Gagal install wezterm. Download manual: https://wezfurlong.org/wezterm/installation.html"
    fi
    ;;
  alpine)
    echo "wezterm tidak tersedia di Alpine. Download manual: https://wezfurlong.org/wezterm/installation.html"
    ;;
esac

# ─── starship (non-Arch) ─────────────────────────────────────────
echo ""
echo "==> Install starship..."
if ! command -v starship &>/dev/null; then
  curl -sS https://starship.rs/install.sh | sh -s -- --yes
else
  echo "starship sudah terinstall."
fi

# ─── atuin (non-Arch) ────────────────────────────────────────────
echo ""
echo "==> Install atuin..."
if ! command -v atuin &>/dev/null; then
  curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
else
  echo "atuin sudah terinstall."
fi

# ─── mise ────────────────────────────────────────────────────────
echo ""
echo "==> Install mise..."
if ! command -v mise &>/dev/null; then
  curl https://mise.run | sh
  echo "mise diinstall ke ~/.local/bin/mise"
  echo "Pastikan ~/.local/bin ada di PATH kamu."
else
  echo "mise sudah terinstall."
fi

# ─── rmpc ────────────────────────────────────────────────────────
echo ""
echo "==> Install rmpc..."
case "$FAMILY" in
  arch)
    aur_install rmpc
    ;;
  *)
    if ! command -v rmpc &>/dev/null; then
      RMPC_URL=$(curl -s https://api.github.com/repos/mierak/rmpc/releases/latest \
        | grep "browser_download_url.*x86_64-unknown-linux-musl.tar.gz" \
        | cut -d '"' -f 4)
      if [[ -n "$RMPC_URL" ]]; then
        curl -Lo /tmp/rmpc.tar.gz "$RMPC_URL"
        tar -xzf /tmp/rmpc.tar.gz -C /tmp
        sudo mv /tmp/rmpc /usr/local/bin/rmpc
        rm /tmp/rmpc.tar.gz
        echo "rmpc berhasil diinstall."
      else
        echo "Gagal fetch rmpc release. Install manual: https://github.com/mierak/rmpc"
      fi
    else
      echo "rmpc sudah terinstall."
    fi
    ;;
esac

# ─── mpDris2 ─────────────────────────────────────────────────────
echo ""
echo "==> Install mpDris2..."
case "$FAMILY" in
  arch)   aur_install mpdris2 ;;
  fedora) pkg_install mpDris2 || echo "mpDris2 tidak ada di repo Fedora. Install manual: https://github.com/eonpatapon/mpDris2" ;;
  debian) pkg_install mpdris2 || echo "mpDris2 tidak ditemukan. Install manual: https://github.com/eonpatapon/mpDris2" ;;
  alpine) echo "mpDris2 tidak tersedia di Alpine. Install manual: https://github.com/eonpatapon/mpDris2" ;;
esac

# ─── fastfetch (non-Arch) ────────────────────────────────────────
echo ""
echo "==> Install fastfetch..."
case "$FAMILY" in
  arch) ;; # sudah diinstall di atas
  fedora)
    pkg_install fastfetch \
      || echo "fastfetch tidak ada di repo default Fedora. Coba: sudo dnf copr enable fastfetch/fastfetch && sudo dnf install fastfetch"
    ;;
  debian)
    if ! command -v fastfetch &>/dev/null; then
      FF_URL=$(curl -s https://api.github.com/repos/fastfetch-cli/fastfetch/releases/latest \
        | grep "browser_download_url.*linux-amd64.deb" \
        | cut -d '"' -f 4)
      if [[ -n "$FF_URL" ]]; then
        curl -Lo /tmp/fastfetch.deb "$FF_URL"
        sudo dpkg -i /tmp/fastfetch.deb
        rm /tmp/fastfetch.deb
      else
        echo "Gagal fetch fastfetch release. Install manual: https://github.com/fastfetch-cli/fastfetch"
      fi
    else
      echo "fastfetch sudah terinstall."
    fi
    ;;
  alpine)
    pkg_install fastfetch \
      || echo "fastfetch tidak ada di Alpine repo. Install manual: https://github.com/fastfetch-cli/fastfetch"
    ;;
esac

# ─── Set zsh sebagai default shell ───────────────────────────────
echo ""
echo "==> Set zsh sebagai default shell..."
if [[ "$SHELL" != "$(command -v zsh)" ]]; then
  chsh -s "$(command -v zsh)"
  echo "Default shell diubah ke zsh. Re-login untuk efektif."
else
  echo "zsh sudah jadi default shell."
fi

# ─── Stow dotfiles ───────────────────────────────────────────────
echo ""
echo "==> Stow dotfiles..."
DOTFILES="${DOTFILES:-$HOME/dotfiles}"

if [[ -d "$DOTFILES" ]]; then
  cd "$DOTFILES"
  stow bash zsh atuin wezterm fastfetch starship mpd mpDris2 rmpc cava scripts fonts
  fc-cache -fv
  echo "Dotfiles berhasil di-stow."
else
  echo "Folder dotfiles tidak ditemukan di $DOTFILES"
  echo "Clone dulu: git clone https://github.com/rimuren/dotfiles.git ~/dotfiles"
fi

# ─── Selesai ─────────────────────────────────────────────────────
echo ""
echo "==> Selesai!"
echo ""
echo "Langkah selanjutnya:"
echo "  1. Re-login atau jalankan: exec zsh"
echo "  2. Clone ZSH plugins manual ke ~/.config/zsh/plugins/manual/"
echo "     - fast-syntax-highlighting"
echo "     - fzf-tab"
echo "     - z"
echo "     - zsh-autopair"
echo "     - zsh-autosuggestions"
echo "     - zsh-completions"
echo "  3. Aktifkan service MPD: systemctl --user enable --now mpd"
echo "  4. Aktifkan mpDris2: systemctl --user enable --now mpDris2"
echo "  5. Maple Mono NF sudah di-stow ke ~/.local/share/fonts/"