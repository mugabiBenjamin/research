#!/usr/bin/env bash
# install_ctf_tools.sh
# Install CTF / forensics / RE / pentest tools (excluding Python/pip tools and Ubuntu defaults)
# Usage:
#   chmod +x install_ctf_tools.sh
#   ./install_ctf_tools.sh [--no-ghidra] [--no-pwndbg] [--minimal]

set -euo pipefail

# --- Configuration ---
TOOLS_DIR="${HOME}/tools"
mkdir -p "${TOOLS_DIR}"
INSTALL_PWNDBG=true
INSTALL_GHIDRA=true
MINIMAL=false

# --- Helpers ---
log()  { printf '\e[1;32m[+] %s\e[0m\n' "$*"; }
warn() { printf '\e[1;33m[!] %s\e[0m\n' "$*"; }
err()  { printf '\e[1;31m[-] %s\e[0m\n' "$*"; exit 1; }

fetch_latest_github_release() {
  local repo="$1" pattern="$2" exclude="${3:-}"
  local result
  result=$(wget -qO- "https://api.github.com/repos/${repo}/releases/latest" \
    2>/dev/null | grep "browser_download_url" \
    | grep -i "${pattern}" | head -1 | cut -d '"' -f 4) || true
  if [ -n "${exclude}" ]; then
    result=$(printf '%s' "${result}" | grep -v "${exclude}") || true
  fi
  printf '%s' "${result}"
}

install_package() {
  local pkg="$1"
  if sudo apt install -y "$pkg" 2>/dev/null; then
    log "Installed $pkg"
  else
    warn "Failed to install $pkg - package may not be available"
  fi
}

ensure_pip3() {
  command -v pip3 >/dev/null 2>&1 || sudo apt install -y python3-pip
}

# Pull Homebrew into PATH early if it exists from a previous install
if [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
elif [ -x "${HOME}/.linuxbrew/bin/brew" ]; then
  eval "$("${HOME}/.linuxbrew/bin/brew" shellenv)"
fi

# Parse flags
for arg in "$@"; do
  case "$arg" in
    --no-ghidra) INSTALL_GHIDRA=false ;;
    --no-pwndbg) INSTALL_PWNDBG=false ;;
    --minimal)   MINIMAL=true ;;
    *) ;;
  esac
done

command -v sudo >/dev/null 2>&1 || err "sudo is required."
export DEBIAN_FRONTEND=noninteractive

if [ ! -f /etc/debian_version ]; then
  warn "This script targets Debian/Ubuntu systems. Proceeding anyway..."
fi

log "Updating package lists..."
sudo apt update -y
log "Upgrading packages..."
sudo apt upgrade -y

# Ensure bootstrap tools exist
command -v wget    >/dev/null 2>&1 || sudo apt install -y wget
command -v unzip   >/dev/null 2>&1 || sudo apt install -y unzip
command -v curl    >/dev/null 2>&1 || sudo apt install -y curl
command -v git     >/dev/null 2>&1 || sudo apt install -y git
command -v bwrap   >/dev/null 2>&1 || sudo apt install -y bubblewrap
command -v gcc     >/dev/null 2>&1 || sudo apt install -y build-essential
command -v vim     >/dev/null 2>&1 || sudo apt install -y vim
command -v objdump >/dev/null 2>&1 || sudo apt install -y binutils
command -v htop    >/dev/null 2>&1 || sudo apt install -y htop
command -v gpg     >/dev/null 2>&1 || sudo apt install -y gnupg
command -v tree    >/dev/null 2>&1 || sudo apt install -y tree

# ─────────────────────────────────────────────
# Package manager setup helpers
# ─────────────────────────────────────────────

# --- Homebrew ---
log "Installing Homebrew..."

source_brew() {
  if [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  elif [ -x "${HOME}/.linuxbrew/bin/brew" ]; then
    eval "$("${HOME}/.linuxbrew/bin/brew" shellenv)"
  fi
}

persist_brew() {
  for rc in ~/.zshrc ~/.bashrc; do
    if ! grep -q 'brew shellenv' "${rc}" 2>/dev/null; then
      echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> "${rc}"
    fi
  done
}

if ! command -v brew >/dev/null 2>&1; then
  NONINTERACTIVE=1 /bin/bash -c \
    "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  source_brew
  persist_brew
  if command -v brew >/dev/null 2>&1; then
    log "Homebrew installed and available in PATH"
  else
    warn "Homebrew installed but still not in PATH — subsequent brew installs may fail"
  fi
else
  warn "Homebrew already installed"
  source_brew
fi

brew_install() {
  local pkg="$1"
  if command -v brew >/dev/null 2>&1; then
    brew upgrade "$pkg" 2>/dev/null || brew install "$pkg" \
      && log "brew: $pkg installed/updated" \
      || warn "brew: failed to install $pkg"
  else
    warn "brew not available; skipping $pkg"
  fi
}

# --- Rust / Cargo ---
log "Installing Rust (rustup)..."
if ! command -v cargo >/dev/null 2>&1; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \
    | sh -s -- -y --no-modify-path
  log "Rust installed"
else
  log "Rust already present — updating..."
  rustup update stable
fi
# Source cargo env for the rest of this script
# shellcheck source=/dev/null
[ -f "${HOME}/.cargo/env" ] && source "${HOME}/.cargo/env"
export PATH="${HOME}/.cargo/bin:${PATH}"

persist_cargo() {
  for rc in ~/.zshrc ~/.bashrc; do
    if ! grep -q 'cargo/env' "${rc}" 2>/dev/null; then
      printf '\n. "%s/.cargo/env"\n' "${HOME}" >> "${rc}"
    fi
  done
}
persist_cargo

cargo_install() {
  local pkg="$1"; shift
  local bin="${1:-$pkg}"
  if command -v cargo >/dev/null 2>&1; then
    cargo install "$pkg" --locked 2>/dev/null \
      && log "cargo: $pkg installed/updated" \
      || warn "cargo: failed to install $pkg"
  else
    warn "cargo not available; skipping $pkg"
  fi
}

# --- Go ---
log "Installing Go (latest)..."
install_go() {
  local latest_url
  latest_url=$(curl -fsSL "https://go.dev/dl/?mode=json" \
    | grep -o '"https://dl.google.com/go/go[^"]*linux-amd64.tar.gz"' \
    | head -1 | tr -d '"') || true
  if [ -z "${latest_url:-}" ]; then
    warn "Could not resolve latest Go download URL"
    return
  fi
  local version
  version=$(basename "${latest_url}" | sed 's/\.linux-amd64\.tar\.gz//')
  local installed_version=""
  [ -x /usr/local/go/bin/go ] && installed_version=$(/usr/local/go/bin/go version 2>/dev/null | awk '{print $3}')
  if [ "${installed_version}" = "${version}" ]; then
    warn "Go ${version} already installed"
  else
    log "Installing Go ${version}..."
    wget -q --show-progress -O /tmp/go.tar.gz "${latest_url}" \
      && sudo rm -rf /usr/local/go \
      && sudo tar -C /usr/local -xzf /tmp/go.tar.gz \
      && rm -f /tmp/go.tar.gz \
      && log "Go ${version} installed" \
      || warn "Failed to install Go"
  fi
}
install_go
export PATH="/usr/local/go/bin:${HOME}/go/bin:${PATH}"

persist_go() {
  for rc in ~/.zshrc ~/.bashrc; do
    if ! grep -q '/usr/local/go/bin' "${rc}" 2>/dev/null; then
      printf '\nexport PATH="/usr/local/go/bin:${HOME}/go/bin:${PATH}"\n' >> "${rc}"
    fi
  done
}
persist_go

go_install() {
  local pkg="$1"
  if command -v go >/dev/null 2>&1; then
    go install "${pkg}@latest" \
      && log "go install: $pkg done" \
      || warn "go install: failed for $pkg"
  else
    warn "go not available; skipping $pkg"
  fi
}

# --- Mamba (via Miniforge) ---
log "Installing Mamba (Miniforge)..."
MINIFORGE_DIR="${HOME}/miniforge3"

install_mamba() {
  local installer_url
  installer_url=$(curl -fsSL "https://api.github.com/repos/conda-forge/miniforge/releases/latest" \
    | grep "browser_download_url" \
    | grep -i "Linux-x86_64.sh" | head -1 | cut -d '"' -f 4)
  if [ -z "${installer_url:-}" ]; then
    warn "Could not resolve Miniforge installer URL"
    return
  fi
  wget -q --show-progress -O /tmp/miniforge.sh "${installer_url}" \
    && bash /tmp/miniforge.sh -b -u -p "${MINIFORGE_DIR}" \
    && rm -f /tmp/miniforge.sh \
    && log "Mamba installed at ${MINIFORGE_DIR}" \
    || warn "Failed to install Mamba"
}

if [ -x "${MINIFORGE_DIR}/bin/mamba" ]; then
  log "Mamba already installed — updating..."
  "${MINIFORGE_DIR}/bin/mamba" update -n base -c conda-forge mamba -y || warn "Mamba update failed"
else
  install_mamba
fi

export PATH="${MINIFORGE_DIR}/bin:${PATH}"

persist_mamba() {
  for rc in ~/.zshrc ~/.bashrc; do
    if ! grep -q 'miniforge3/bin' "${rc}" 2>/dev/null; then
      printf '\nexport PATH="%s/bin:${PATH}"\n' "${MINIFORGE_DIR}" >> "${rc}"
    fi
  done
}
persist_mamba

mamba_install() {
  local pkg="$1" channel="${2:-conda-forge}"
  if command -v mamba >/dev/null 2>&1; then
    mamba install -n base -c "${channel}" -y "$pkg" \
      && log "mamba: $pkg installed/updated" \
      || warn "mamba: failed to install $pkg"
  else
    warn "mamba not available; skipping $pkg"
  fi
}

# --- Ruby / Gem ---
ensure_gem() {
  if ! command -v gem >/dev/null 2>&1; then
    sudo apt install -y ruby ruby-dev build-essential
  fi
}

gem_install() {
  local pkg="$1"
  ensure_gem
  sudo gem install "$pkg" \
    && log "gem: $pkg installed/updated" \
    || warn "gem: failed to install $pkg"
}

# --- pip ---
ensure_pip3

pip_install() {
  local pkg="$1"
  pip3 install --upgrade "$pkg" --break-system-packages \
    && log "pip: $pkg installed/updated" \
    || warn "pip: failed to install $pkg"
}

# ─────────────────────────────────────────────
# Package Installation
# ─────────────────────────────────────────────

if [ "${MINIMAL}" = true ]; then
  log "Installing MINIMAL package set..."
  sudo apt install -y \
    nmap tcpdump \
    binwalk strace ltrace radare2 \
    hashcat john \
    tmux p7zip-full \
    ruby ruby-dev build-essential

  gem_install zsteg

else
  log "Installing FULL package set..."

  log "Installing networking tools..."
  sudo apt install -y nmap tcpdump wireshark tshark

  log "Configuring Wireshark packet capture for non-root users..."
  echo "wireshark-common wireshark-common/install-setuid boolean true" | sudo debconf-set-selections
  sudo DEBIAN_FRONTEND=noninteractive dpkg-reconfigure -f noninteractive wireshark-common
  sudo usermod -aG wireshark "$USER"

  log "Installing masscan..."
  if ! command -v masscan >/dev/null 2>&1; then
    sudo apt install -y masscan && log "masscan installed" || warn "Failed to install masscan"
  else
    warn "masscan already installed"
  fi

  log "Installing SMB / Windows enumeration tools..."
  sudo apt install -y smbclient

  log "Installing web fuzzing and enumeration tools..."
  sudo apt install -y ffuf

  log "Installing feroxbuster..."
  mkdir -p "${HOME}/.local/bin"
  case ":${PATH}:" in
    *":${HOME}/.local/bin:"*) ;;
    *) export PATH="${HOME}/.local/bin:${PATH}" ;;
  esac
  if ! command -v feroxbuster >/dev/null 2>&1; then
    FEROX_SCRIPT="/tmp/ferox-install.sh"
    curl -fsSL https://raw.githubusercontent.com/epi052/feroxbuster/main/install-nix.sh \
      -o "${FEROX_SCRIPT}" \
      && chmod +x "${FEROX_SCRIPT}" \
      && bash "${FEROX_SCRIPT}" "${HOME}/.local/bin" \
      && rm -f "${FEROX_SCRIPT}" \
      && log "feroxbuster installed to ${HOME}/.local/bin" \
      || { warn "Failed to install feroxbuster"; rm -f "${FEROX_SCRIPT}"; }
  else
    warn "feroxbuster already installed"
  fi

  log "Installing Amass..."
  if command -v amass >/dev/null 2>&1; then
    warn "amass already installed"
  else
    brew_install amass
  fi

  log "Installing subfinder..."
  if command -v subfinder >/dev/null 2>&1; then
    warn "subfinder already installed"
  else
    go_install github.com/projectdiscovery/subfinder/v2/cmd/subfinder
  fi

  log "Installing RustScan..."
  if command -v rustscan >/dev/null 2>&1; then
    warn "rustscan already installed"
  else
    brew_install rustscan
  fi

  log "Installing Naabu..."
  if command -v naabu >/dev/null 2>&1; then
    warn "naabu already installed"
  else
    go_install github.com/projectdiscovery/naabu/v2/cmd/naabu
  fi

  log "Installing httpx..."
  go_install github.com/projectdiscovery/httpx/cmd/httpx

  log "Installing nuclei..."
  go_install github.com/projectdiscovery/nuclei/v3/cmd/nuclei

  log "Installing dnsx..."
  go_install github.com/projectdiscovery/dnsx/cmd/dnsx

  log "Installing binary analysis tools..."
  sudo apt install -y radare2 binwalk strace ltrace upx-ucl

  log "Installing reverse engineering extras..."
  if ! sudo apt install -y rizin 2>/dev/null; then
    warn "rizin not in apt - trying .deb from GitHub..."
    RIZIN_URL=$(fetch_latest_github_release \
      "rizinorg/rizin" "linux.*amd64\.deb\|linux.*x86_64\.deb")
    if [ -n "${RIZIN_URL:-}" ]; then
      wget -q --show-progress -O /tmp/rizin.deb "${RIZIN_URL}" \
        && sudo dpkg -i /tmp/rizin.deb \
        && sudo apt install -f -y \
        && rm -f /tmp/rizin.deb \
        && log "rizin installed via .deb" \
        || { warn "Failed to install rizin"; rm -f /tmp/rizin.deb; }
    else
      warn "Could not install rizin - install manually from https://github.com/rizinorg/rizin/releases"
    fi
  fi

  log "Installing cutter..."
  if command -v cutter >/dev/null 2>&1; then
    warn "cutter already installed, skipping"
  elif [ -f "${TOOLS_DIR}/cutter.AppImage" ]; then
    warn "cutter AppImage already exists, linking..."
    chmod +x "${TOOLS_DIR}/cutter.AppImage"
    sudo ln -sf "${TOOLS_DIR}/cutter.AppImage" /usr/local/bin/cutter
  else
    if ! sudo apt install -y cutter 2>/dev/null; then
      warn "cutter not in apt - installing latest AppImage..."
      CUTTER_URL=$(fetch_latest_github_release \
        "rizinorg/cutter" "AppImage" "\.zsync")
      if [ -n "${CUTTER_URL:-}" ]; then
        wget -q --show-progress -O "${TOOLS_DIR}/cutter.AppImage" "${CUTTER_URL}" \
          && chmod +x "${TOOLS_DIR}/cutter.AppImage" \
          && sudo ln -sf "${TOOLS_DIR}/cutter.AppImage" /usr/local/bin/cutter \
          && log "cutter installed"
      else
        warn "Could not find cutter AppImage URL"
      fi
    fi
  fi

  log "Installing JD-GUI..."
  if command -v jd-gui >/dev/null 2>&1; then
    warn "jd-gui already installed"
  else
    JDGUI_URL=$(fetch_latest_github_release "java-decompiler/jd-gui" "\.jar$")
    JDGUI_JAR="${TOOLS_DIR}/jd-gui.jar"
    if [ -n "${JDGUI_URL:-}" ]; then
      wget -q --show-progress -O "${JDGUI_JAR}" "${JDGUI_URL}" \
        || warn "Failed to download JD-GUI"
    fi
    if [ -f "${JDGUI_JAR}" ]; then
      printf '#!/bin/sh\nexec java -jar %s "$@"\n' "${JDGUI_JAR}" \
        | sudo tee /usr/local/bin/jd-gui > /dev/null
      sudo chmod +x /usr/local/bin/jd-gui
      log "jd-gui installed"
    else
      warn "JD-GUI jar not found - install manually"
    fi
  fi

  log "Installing forensics tools..."
  sudo apt install -y foremost scalpel libimage-exiftool-perl steghide gddrescue \
    ruby ruby-dev build-essential

  log "Installing outguess from source..."
  if ! command -v outguess >/dev/null 2>&1; then
    sudo apt install -y autoconf libglib2.0-dev \
      && git clone https://github.com/crorvick/outguess "${TOOLS_DIR}/outguess" \
      && ( cd "${TOOLS_DIR}/outguess" && ./configure && make && sudo make install ) \
      && log "outguess installed" \
      || warn "Failed to install outguess from source"
  else
    warn "outguess already installed"
  fi

  log "Installing steganography extras..."
  sudo apt install -y zbar-tools mat2
  for pkg in stegseek sonic-visualiser; do
    install_package "$pkg"
  done

  log "Installing media analysis tools..."
  sudo apt install -y ffmpeg mediainfo sox imagemagick

  log "Installing system monitoring tools..."
  sudo apt install -y tmux p7zip-full iotop sysstat lsof linux-tools-generic valgrind

  log "Installing password cracking tools..."
  sudo apt install -y hashcat john hydra fcrackzip
  install_package pdfcrack

  log "Installing text processing tools..."
  sudo apt install -y jq xmlstarlet pandoc

  log "Installing optional web/enumeration tools..."
  for pkg in dirb gobuster wfuzz sqlmap nikto; do
    install_package "$pkg"
  done

  log "Installing optional forensics tools..."
  for pkg in testdisk sleuthkit autopsy; do
    install_package "$pkg"
  done

  log "Installing optional security auditing tools..."
  for pkg in chkrootkit rkhunter lynis aide; do
    install_package "$pkg"
  done

  log "Installing Metasploit Framework..."
  if ! command -v msfconsole >/dev/null 2>&1; then
    MSF_SCRIPT="/tmp/msfinstall"
    curl -fsSL \
      https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb \
      -o "${MSF_SCRIPT}" \
      && chmod +x "${MSF_SCRIPT}" \
      && sudo "${MSF_SCRIPT}" \
      && rm -f "${MSF_SCRIPT}" \
      && log "Metasploit installed" \
      || { warn "Failed to install Metasploit"; rm -f "${MSF_SCRIPT}"; }
  else
    warn "Metasploit already installed"
  fi

  # ── Cargo tools ──────────────────────────────
  log "Installing Cargo tools..."
  cargo_install ripgrep rg
  cargo_install fd-find fd
  cargo_install bat
  cargo_install hexyl
  cargo_install tokei

  # ── Go tools ─────────────────────────────────
  log "Installing Go tools..."
  go_install github.com/tomnomnom/waybackurls
  go_install github.com/tomnomnom/gf
  go_install github.com/tomnomnom/anew
  go_install github.com/lc/gau/v2/cmd/gau
  go_install github.com/hakluke/hakrawler

  # ── Mamba packages ───────────────────────────
  log "Installing Mamba packages..."
  mamba_install sage

  # ── pip tools ────────────────────────────────
  log "Installing pip tools..."
  pip_install pwntools
  pip_install requests
  pip_install beautifulsoup4
  pip_install scapy
  pip_install cryptography
  pip_install volatility3
  pip_install ROPgadget
  pip_install xortool

  # ── gem tools ────────────────────────────────
  log "Installing gem tools..."
  gem_install zsteg
  gem_install one_gadget

  log "Installing checksec..."
  if ! sudo apt install -y checksec 2>/dev/null; then
    warn "checksec not in apt - trying pip3..."
    pip_install checksec.sh
  fi

  # --- pwndbg ---
  if [ "${INSTALL_PWNDBG}" = true ]; then
    log "Installing pwndbg..."
    if [ ! -d "${TOOLS_DIR}/pwndbg" ]; then
      git clone https://github.com/pwndbg/pwndbg "${TOOLS_DIR}/pwndbg" \
        || warn "Failed to clone pwndbg"
    else
      warn "pwndbg directory already exists, skipping clone"
    fi
    if [ -d "${TOOLS_DIR}/pwndbg" ]; then
      ( cd "${TOOLS_DIR}/pwndbg" && bash setup.sh ) \
        && log "pwndbg installed" \
        || warn "pwndbg setup.sh failed"
    fi
  else
    warn "Skipping pwndbg (--no-pwndbg flag set)"
  fi

  # --- Ghidra ---
  if [ "${INSTALL_GHIDRA}" = true ]; then
    log "Installing Ghidra (latest)..."
    GHIDRA_EXISTING=$(find "${TOOLS_DIR}" -maxdepth 1 -type d -name 'ghidra_*' | head -1)
    if [ -n "${GHIDRA_EXISTING}" ]; then
      warn "Ghidra already exists at ${GHIDRA_EXISTING}, skipping"
    elif command -v ghidraRun >/dev/null 2>&1; then
      warn "Ghidra command already available, skipping"
    else
      GHIDRA_URL=$(fetch_latest_github_release \
        "NationalSecurityAgency/ghidra" "PUBLIC.*\.zip$")
      if [ -z "${GHIDRA_URL:-}" ]; then
        warn "Could not resolve Ghidra release URL — install manually"
      else
        GHIDRA_ZIP=$(basename "${GHIDRA_URL}")
        sudo apt install -y default-jdk || warn "Failed to install JDK (required for Ghidra)"
        wget -q --show-progress -O "/tmp/${GHIDRA_ZIP}" "${GHIDRA_URL}" \
          || warn "Failed to download Ghidra"
        if [ -f "/tmp/${GHIDRA_ZIP}" ]; then
          unzip -q "/tmp/${GHIDRA_ZIP}" -d "${TOOLS_DIR}/" \
            && rm -f "/tmp/${GHIDRA_ZIP}" \
            && log "Ghidra extracted to ${TOOLS_DIR}" \
            || warn "Failed to unzip Ghidra"
        fi
      fi
    fi
  else
    warn "Skipping Ghidra (--no-ghidra flag set)"
  fi

  warn "burpsuite not available in apt - install manually from https://portswigger.net/burp/communitydownload"
fi

log "APT install finished."
log "Tools directory: ${TOOLS_DIR}"

log "Verifying installed commands..."
for cmd in vim objdump htop gpg tree brew nmap rustscan naabu masscan amass subfinder \
           binwalk radare2 hashcat john jq zsteg ffuf feroxbuster fcrackzip smbclient \
           zbarimg mat2 ROPgadget xortool msfconsole upx jd-gui \
           cargo rustc go mamba \
           rg fd bat hexyl tokei \
           httpx nuclei dnsx waybackurls gau hakrawler; do
  if command -v "${cmd}" >/dev/null 2>&1; then
    printf '  %-16s: installed\n' "${cmd}"
  else
    warn "Command '${cmd}' not found"
  fi
done

cat <<'EOF'

=====================================================================
Installation complete.

Manual steps required:
 - Install burpsuite from: https://portswigger.net/burp/communitydownload

 - Install tplmap (SSTI scanner):
   git clone https://github.com/epinna/tplmap.git ~/tools/tplmap
   pip3 install -r ~/tools/tplmap/requirements.txt --break-system-packages
   sudo ln -s ~/tools/tplmap/tplmap.py /usr/local/bin/tplmap
   chmod +x ~/tools/tplmap/tplmap.py

 - Install enum4linux-ng (not in apt):
   git clone https://github.com/cddmp/enum4linux-ng.git ~/tools/enum4linux-ng
   pip3 install -r ~/tools/enum4linux-ng/requirements.txt --break-system-packages
   sudo ln -s ~/tools/enum4linux-ng/enum4linux-ng.py /usr/local/bin/enum4linux-ng

 - Install Responder (not in apt):
   git clone https://github.com/lgandx/Responder.git ~/tools/Responder
   # Run with: sudo python3 ~/tools/Responder/Responder.py -I <interface>

 - Activate mamba in your shell (first time):
   ~/miniforge3/bin/conda init bash   # or zsh
   # then restart your shell

# Excluded (already in Ubuntu):
#  - curl, wget, netcat, git, gcc, gdb, file, xxd
#  - openssl, gnupg, python3

EOF

log "Done — CTF tools installed!"