# App List

Daftar semua aplikasi yang dipakai di dotfiles ini.

## Shell & Terminal

| App      | Keterangan                    |
| -------- | ----------------------------- |
| zsh      | Shell utama                   |
| bash     | Shell fallback                |
| wezterm  | Terminal emulator             |
| starship | Prompt shell                  |
| atuin    | Shell history manager         |
| micro    | Editor teks (EDITOR & VISUAL) |

## ZSH Plugins (manual)

| Plugin                   | Keterangan                  |
| ------------------------ | --------------------------- |
| fast-syntax-highlighting | Syntax highlighting di zsh  |
| fzf-tab                  | Tab completion dengan fzf   |
| z                        | Directory jumping           |
| zsh-autopair             | Auto-close brackets/quotes  |
| zsh-autosuggestions      | Saran perintah dari history |
| zsh-completions          | Koleksi completion tambahan |

## CLI Tools

| App          | Keterangan                                    |
| ------------ | --------------------------------------------- |
| fzf          | Fuzzy finder                                  |
| eza          | ls modern (pengganti ls)                      |
| fd           | find modern (dipakai di ff())                 |
| bat          | cat dengan syntax highlight (preview di ff()) |
| chafa        | Preview gambar di terminal (dipakai di ff())  |
| xclip        | Copy ke clipboard X11 (Ctrl+Y di ff())        |
| wl-clipboard | Copy ke clipboard Wayland (Ctrl+Y di ff())    |
| xdg-utils    | xdg-open untuk buka file                      |
| nmap         | Network scanner (nscan())                     |
| mise         | Runtime version manager                       |
| stow         | Symlink manager untuk dotfiles                |
| git          | Version control                               |
| mpc          | MPD CLI client                                |
| poppler      | pdftotext untuk preview PDF di ff()           |

## Musik

| App      | Keterangan                                     |
| -------- | ---------------------------------------------- |
| mpd      | Music Player Daemon                            |
| rmpc     | MPD TUI client                                 |
| mpDris2  | MPD ke MPRIS2 bridge (notifikasi & media keys) |
| cava     | Audio visualizer terminal                      |
| pipewire | Audio server (output MPD)                      |

## System & Desktop

| App          | Keterangan                                |
| ------------ | ----------------------------------------- |
| fastfetch    | System info fetcher (startup zsh)         |
| bluetoothctl | Bluetooth manager (blue())                |
| gsettings    | GNOME settings CLI (wallctl)              |
| systemd      | Service manager (mpd, bluetooth, mpDris2) |

## Fonts (diperlukan untuk icon)

| Font           | Keterangan                                                   |
| -------------- | ------------------------------------------------------------ |
| Maple Mono NF  | Font utama terminal & editor, include Nerd Font icons        |
| Maple Mono TTF | Versi tanpa Nerd Font (fallback / non-terminal)              |

Font di-manage via stow dari `~/dotfiles/fonts/` → `~/.local/share/fonts/`.
Jalankan `fc-cache -fv` setelah stow untuk refresh font cache.

---

## Panduan Setup MPD Stack

### Prasyarat

```bash
sudo pacman -S mpd mpc rmpc pipewire pipewire-pulse wireplumber cava
yay -S mpdris2
```

### 1. Buat folder yang dibutuhkan

```bash
mkdir -p ~/.config/mpd/component ~/.config/mpd/playlists
```

### 2. Stow config

```bash
cd ~/dotfiles
stow mpd mpDris2 rmpc cava
```

### 3. Pastikan music_directory di mpd.conf sesuai mount point

Buka `~/.config/mpd/mpd.conf` dan sesuaikan:

```
music_directory "/mnt/storage/Music/Flac"  # sesuaikan dengan path musik kamu
```

Cek mount point storage dengan:

```bash
lsblk
```

### 4. Aktifkan service

```bash
systemctl --user enable --now mpd
systemctl --user enable --now mpDris2
```

Nama service mpDris2 case-sensitive: `mpDris2.service` bukan `mpdris2`.

### 5. Verifikasi

```bash
systemctl --user status mpd mpDris2
mpc status
```

### 6. Update database musik

```bash
mpc update
```

---

## MPD / MPC Commands

### mpc (CLI client)

| Command                    | Keterangan                    |
| -------------------------- | ----------------------------- |
| `mpc status`               | Status playback sekarang      |
| `mpc play`                 | Mulai play                    |
| `mpc pause`                | Pause                         |
| `mpc stop`                 | Stop                          |
| `mpc next`                 | Lagu berikutnya               |
| `mpc prev`                 | Lagu sebelumnya               |
| `mpc toggle`               | Play/pause toggle             |
| `mpc volume +5`            | Naikkan volume 5%             |
| `mpc volume -5`            | Turunkan volume 5%            |
| `mpc seek +10`             | Maju 10 detik                 |
| `mpc seek -10`             | Mundur 10 detik               |
| `mpc random on/off`        | Toggle random                 |
| `mpc repeat on/off`        | Toggle repeat                 |
| `mpc single on/off`        | Toggle single                 |
| `mpc consume on/off`       | Toggle consume                |
| `mpc update`               | Update database musik         |
| `mpc rescan`               | Rescan database dari awal     |
| `mpc ls`                   | List direktori musik          |
| `mpc search artist "nama"` | Cari berdasarkan artist       |
| `mpc add "path"`           | Tambah lagu ke queue          |
| `mpc clear`                | Kosongkan queue               |
| `mpc playlist`             | Lihat queue sekarang          |
| `mpc load "nama"`          | Load saved playlist           |
| `mpc save "nama"`          | Simpan queue sebagai playlist |

### systemctl (service management)

| Command                            | Keterangan            |
| ---------------------------------- | --------------------- |
| `systemctl --user start mpd`       | Jalankan MPD          |
| `systemctl --user stop mpd`        | Stop MPD              |
| `systemctl --user restart mpd`     | Restart MPD           |
| `systemctl --user status mpd`      | Status MPD            |
| `systemctl --user enable mpd`      | Auto-start saat login |
| `systemctl --user start mpDris2`   | Jalankan mpDris2      |
| `systemctl --user restart mpDris2` | Restart mpDris2       |

### Catatan

- MPD menggunakan Unix socket di `~/.config/mpd/socket`, bukan TCP port
- `pid_file` di config akan diabaikan saat MPD jalan via systemd (normal)
- CAVA membaca audio dari FIFO `/tmp/mpd.fifo` yang di-output MPD secara otomatis
- mpDris2 menghubungkan MPD ke MPRIS2 sehingga media keys dan notifikasi GNOME bekerja
