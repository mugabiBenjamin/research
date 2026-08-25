# Terminal Setup on Ubuntu: Terminator, Zsh, Oh My Zsh, Powerlevel10k & Tmux

This guide covers setting up a productive, visually rich terminal environment on a fresh Ubuntu installation. By the end, your terminal will display the current git branch, time, and other useful context in a clean prompt.

## 1. Terminator (Terminal Emulator)

Terminator replaces the default Ubuntu terminal (Ptyxis) and supports split panes.

```bash
sudo apt install terminator
```

Set it as the default terminal:

```bash
sudo update-alternatives --config x-terminal-emulator
# Select terminator from the list

gsettings set org.gnome.desktop.default-applications.terminal exec terminator
gsettings set org.gnome.desktop.default-applications.terminal exec-arg ""
```

To bind `Ctrl+Alt+T` to Terminator, go to **Settings → Keyboard → Keyboard Shortcuts → System → Open Terminal** and set the command to `terminator`.

## 2. Zsh

Zsh is likely already installed on Ubuntu 24.04+. Verify:

```bash
zsh --version
```

If not installed:

```bash
sudo apt install zsh
```

Set Zsh as your default shell:

```bash
chsh -s $(which zsh)
```

Log out and back in for the change to take effect.

## 3. Oh My Zsh

Oh My Zsh is a framework for managing Zsh configuration, themes, and plugins.

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

This creates `~/.zshrc` and `~/.oh-my-zsh/`.

## 4. Powerlevel10k (Theme)

Powerlevel10k is a fast, highly customizable Zsh theme that displays git branch, time, exit codes, and more.

### Install

```bash
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
  ~/.oh-my-zsh/custom/themes/powerlevel10k
```

### Enable

Edit `~/.zshrc` and set:

```bash
ZSH_THEME="powerlevel10k/powerlevel10k"
```

Add this line at the end of `~/.zshrc` to ensure the theme loads:

```bash
source ~/.oh-my-zsh/custom/themes/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
```

Reload and run the configuration wizard:

```bash
source ~/.zshrc
p10k configure
```

Follow the interactive wizard to select your preferred prompt style, icons, time format, and git indicators.

> **Note:** For best results, install a [Nerd Font](https://www.nerdfonts.com/) and set it in Terminator's preferences (**Right-click → Preferences → Profiles → Font**).

## 5. Oh My Zsh Plugins

Plugins add functionality like autosuggestions, syntax highlighting, and command completion.

### Recommended plugins

**zsh-autosuggestions** — suggests commands as you type based on history:

```bash
git clone https://github.com/zsh-users/zsh-autosuggestions \
  ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
```

**zsh-syntax-highlighting** — highlights valid/invalid commands in real time:

```bash
git clone https://github.com/zsh-users/zsh-syntax-highlighting \
  ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
```

### Enable plugins

Edit `~/.zshrc` and update the plugins line:

```bash
plugins=(git zsh-autosuggestions zsh-syntax-highlighting z sudo)
```

- `git` — git aliases and branch info
- `z` — jump to frecent directories
- `sudo` — double-tap `Esc` to prepend sudo to last command

Reload:

```bash
source ~/.zshrc
```

## 6. Tmux (Terminal Multiplexer)

Tmux lets you split the terminal, run multiple sessions, and persist sessions across disconnections.

### Installation

```bash
sudo apt install tmux
```

### Basic usage

```bash
tmux                    # start a new session
Ctrl+B %               # split vertically
Ctrl+B "               # split horizontally
Ctrl+B arrow keys      # navigate panes
Ctrl+B d               # detach session
tmux attach            # reattach to last session
```

### Optional: persist Tmux sessions across reboots

Install [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm):

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Create `~/.tmux.conf`:

```bash
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-resurrect'

run '~/.tmux/plugins/tpm/tpm'
```

Inside Tmux, press `Ctrl+B I` to install plugins.

## Summary

| Component     | Purpose                                | Installed via  |
| ------------- | -------------------------------------- | -------------- |
| Terminator    | Terminal emulator with split panes     | `apt`          |
| Zsh           | Shell                                  | `apt`          |
| Oh My Zsh     | Zsh framework                          | install script |
| Powerlevel10k | Prompt theme (branch, time, etc.)      | `git clone`    |
| OMZ Plugins   | Autosuggestions, highlighting, aliases | `git clone`    |
| Tmux          | Terminal multiplexer                   | `apt`          |
