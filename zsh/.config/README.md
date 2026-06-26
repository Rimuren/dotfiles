# 🐚 Zsh Configuration

This directory contains a **modular Zsh configuration** used in my personal Linux setup.

The goal of this configuration is to keep the shell:

* fast
* minimal
* modular
* easy to debug
* plugin-light

Instead of using a plugin manager, plugins are **stored directly in the repository**.

---

# 📁 Directory Structure

```
zsh/
└── .config/zsh/
    ├── 00-env.zsh          # XDG, PATH, editor, env vars
    ├── 01-options.zsh      # shell options
    ├── 02-history.zsh      # history file & size
    ├── 03-completion.zsh   # compinit, zstyle, cache
    ├── 04-plugins.zsh      # plugin loader (core + lazy)
    ├── 05-aliases.zsh      # aliases
    ├── 40-init.zsh         # mise, starship, atuin init
    ├── 41-keybind.zsh      # ZLE keybindings
    ├── 50-startup.zsh      # fastfetch on interactive shell
    ├── helpers/
    │   └── 10-fzf.zsh      # fzfui() wrapper
    └── plugins/
        └── manual/         # vendored plugins
```

---

# ⚙️ Configuration Design

The configuration follows a **numbered loading system**.

`.zshrc` loads files automatically in order:

```
00 → environment vars
01 → shell options
02 → history
03 → completion
04 → plugins (core eager + lazy via precmd)
05 → aliases
40 → tool inits (mise, starship, atuin)   # 40-init.zsh
41 → ZLE keybindings (runs after tool inits)
50 → startup display (fastfetch)
```

This approach makes the config:

* predictable
* easy to extend
* easy to debug

---

# 🔧 Helpers

Helper functions are stored in:

```
helpers/
```

Example:

```
helpers/10-fzf.zsh
```

Provides a reusable **fzf UI wrapper** used across the config.

Example usage:

```
fzfui --prompt="Select > "
```

---

# 🖥️ CLI Tools

Interactive terminal tools live in:

```
ui/
```

Included tools:

### bluetooth

Interactive Bluetooth manager using:

```
blue
```
<details>
<summary>Preview blue</summary>

![bluetooth preview](../../asset/screenshot/zsh/bluetooth.png)

</details>

### finder

File finder with preview using:

```
ff
```
<details>
<summary>Preview ff</summary>

![file finder preview](../../asset/screenshot/zsh/file_finder.png)

</details>

Uses:

* fd
* bat
* chafa
* eza

### nmap helper

Interactive network scanner:

```
nscan
```
<details>
<summary>Preview nscan</summary>

![nscan preview](../../asset/screenshot/zsh/nscan.png)

</details>

### mise runtime manager

Interactive runtime manager UI:

```
miseui
```

about mise : 
```bash
https://mise.jdx.dev/getting-started.html
```
<details>
<summary>Preview miseui</summary>

![miseui preview](../../asset/screenshot/zsh/miseui.png)

</details>

Supports:

* install runtimes
* switch versions
* manage plugins
* update runtimes

---

# 🔌 Plugins

Plugins are stored locally:

```
plugins/manual
```

Included:

* fast-syntax-highlighting
* fzf-tab
* z
* zsh-autopair
* zsh-autosuggestions
* zsh-completions

This avoids dependency on external plugin managers.

---

# 🚀 Features

The shell includes:

* fast startup
* lazy-loaded plugins
* fzf-powered CLI tools
* interactive helpers
* modular configuration

---

# 🧠 Philosophy

This shell setup follows a few principles:

* **minimalism**
* **terminal-driven environment**
* **modular configuration**

The goal is to keep the shell **powerful without becoming complex**.

---

# 📜 Notes

Tested mainly on:

* Arch Linux
* Wayland environments
* Nerd Fonts enabled terminals
