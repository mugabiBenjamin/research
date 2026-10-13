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
command -v wget  >/dev/null 2>&1 || sudo apt install -y wget
command -v unzip >/dev/null 2>&1 || sudo apt install -y unzip
command -v curl  >/dev/null 2>&1 || sudo apt install -y curl
command -v git   >/dev/null 2>&1 || sudo apt install -y git
command -v bwrap >/dev/null 2>&1 || sudo apt install -y bubblewrap
command -v gcc   >/dev/null 2>&1 || sudo apt install -y build-essential
command -v vim   >/dev/null 2>&1 || sudo apt install -y vim
command -v objdump >/dev/null 2>&1 || sudo apt install -y binutils
command -v htop  >/dev/null 2>&1 || sudo apt install -y htop
command -v gpg   >/dev/null 2>&1 || sudo apt install -y gnupg
command -v tree  >/dev/null 2>&1 || sudo apt install -y tree

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

# --- Package Installation ---
if [ "${MINIMAL}" = true ]; then
  log "Installing MINIMAL package set..."
  sudo apt install -y \
    nmap tcpdump \
    binwalk strace ltrace radare2 \
    hashcat john \
    tmux p7zip-full \
    ruby ruby-dev build-essential

  log "Installing zsteg..."
  sudo gem install zsteg || warn "Failed to install zsteg via gem"

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
    if command -v brew >/dev/null 2>&1; then
      brew install amass && log "amass installed" || warn "Failed to install amass via brew"
    else
      warn "brew not found; cannot install amass"
    fi
  fi

  log "Installing subfinder..."
  if command -v subfinder >/dev/null 2>&1; then
    warn "subfinder already installed"
  else
    SUBFINDER_URL=$(fetch_latest_github_release \
      "projectdiscovery/subfinder" "linux_amd64.zip")
    if [ -n "${SUBFINDER_URL:-}" ]; then
      wget -q --show-progress -O /tmp/subfinder.zip "${SUBFINDER_URL}" \
        && unzip -o /tmp/subfinder.zip -d /tmp/subfinder-install \
        && sudo install /tmp/subfinder-install/subfinder /usr/local/bin/subfinder \
        && rm -rf /tmp/subfinder.zip /tmp/subfinder-install \
        && log "subfinder installed" \
        || { warn "Failed to install subfinder"; rm -rf /tmp/subfinder.zip /tmp/subfinder-install; }
    else
      warn "Could not find subfinder release URL"
    fi
  fi

  log "Installing RustScan..."
  if command -v rustscan >/dev/null 2>&1; then
    warn "rustscan already installed"
  else
    source_brew
    if command -v brew >/dev/null 2>&1; then
      brew install rustscan \
        && command -v rustscan >/dev/null 2>&1 \
        && log "rustscan installed" \
        || warn "Failed to install rustscan via brew"
    else
      warn "brew not found; cannot install rustscan"
    fi
  fi

  log "Installing Naabu..."
  if command -v naabu >/dev/null 2>&1; then
    warn "naabu already installed"
  else
    NAABU_URL=$(fetch_latest_github_release \
      "projectdiscovery/naabu" "linux_amd64.zip")
    if [ -n "${NAABU_URL:-}" ]; then
      wget -q --show-progress -O /tmp/naabu.zip "${NAABU_URL}" \
        && unzip -o /tmp/naabu.zip -d /tmp/naabu-install \
        && sudo install /tmp/naabu-install/naabu /usr/local/bin/naabu \
        && rm -rf /tmp/naabu.zip /tmp/naabu-install \
        && log "naabu installed" \
        || { warn "Failed to install naabu"; rm -rf /tmp/naabu.zip /tmp/naabu-install; }
    else
      warn "Could not find Naabu release"
    fi
  fi

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

  warn "sagemath requires manual install - use https://sagecell.sagemath.org for quick crypto or install locally via: conda install sage -c conda-forge"

  ensure_pip3

  log "Installing checksec..."
  if ! sudo apt install -y checksec 2>/dev/null; then
    warn "checksec not in apt - trying pip3..."
    pip3 install checksec.sh --break-system-packages || warn "Failed to install checksec"
  fi

  log "Installing zsteg..."
  sudo gem install zsteg || warn "Failed to install zsteg via gem"

  log "Installing one_gadget via gem..."
  sudo gem install one_gadget || warn "Failed to install one_gadget via gem"

  log "Installing ROPgadget..."
  pip3 install ROPgadget --break-system-packages || warn "Failed to install ROPgadget"

  log "Installing xortool..."
  pip3 install xortool --break-system-packages || warn "Failed to install xortool"

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
           zbarimg mat2 ROPgadget xortool msfconsole upx jd-gui; do
  if command -v "${cmd}" >/dev/null 2>&1; then
    printf '  %-14s: installed\n' "${cmd}"
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

 - Install Python tools in virtual environment:
   python3 -m venv ctf_env
   source ctf_env/bin/activate
   pip install pwntools requests beautifulsoup4 scapy cryptography volatility3

# Excluded (already in Ubuntu):
#  - curl, wget, netcat, git, gcc, gdb, file, xxd, binutils
#  - openssl, gnupg, python3

EOF

log "Done — CTF tools installed!"