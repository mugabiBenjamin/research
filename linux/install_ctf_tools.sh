#!/usr/bin/env bash
# install_ctf_tools.sh
# Install CTF / forensics / RE / pentest tools (excluding Python/pip tools and Ubuntu defaults)
# Usage:
#   chmod +x install_ctf_tools.sh
#   ./install_ctf_tools.sh [--no-ghidra] [--no-pwndbg] [--minimal]

set -euo pipefail

# --- Configuration ---
GHIDRA_VERSION="10.4_PUBLIC_20230928"
GHIDRA_ZIP="ghidra_${GHIDRA_VERSION}.zip"
GHIDRA_URL="https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_10.4_build/${GHIDRA_ZIP}"
TOOLS_DIR="${HOME}/tools"
mkdir -p "${TOOLS_DIR}"
INSTALL_PWNDDBG=true
INSTALL_GHIDRA=true
MINIMAL=false

# Parse flags
for arg in "$@"; do
  case "$arg" in
    --no-ghidra) INSTALL_GHIDRA=false ;;
    --no-pwndbg) INSTALL_PWNDDBG=false ;;
    --minimal) MINIMAL=true ;;
    *) ;;
  esac
done

# --- Helpers ---
log()  { printf '\e[1;32m[+] %s\e[0m\n' "$*"; }
warn() { printf '\e[1;33m[!] %s\e[0m\n' "$*"; }
err()  { printf '\e[1;31m[-] %s\e[0m\n' "$*"; exit 1; }

install_package() {
  local pkg="$1"
  if sudo apt install -y "$pkg" 2>/dev/null; then
    log "Installed $pkg"
  else
    warn "Failed to install $pkg - package may not be available"
  fi
}

command -v sudo >/dev/null 2>&1 || err "sudo is required."
export DEBIAN_FRONTEND=noninteractive

# Basic checks
if [ ! -f /etc/debian_version ]; then
  warn "This script targets Debian/Ubuntu systems. Proceeding anyway..."
fi

log "Updating package lists..."
sudo apt update -y
log "Upgrading packages..."
sudo apt upgrade -y

# Ensure required tools exist
command -v wget >/dev/null 2>&1 || sudo apt install -y wget
command -v unzip >/dev/null 2>&1 || sudo apt install -y unzip

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

  log "Installing SMB / Windows enumeration tools..."
  sudo apt install -y smbclient

  log "Installing web fuzzing and enumeration tools..."
  sudo apt install -y ffuf

  log "Installing feroxbuster..."
  if ! command -v feroxbuster >/dev/null 2>&1; then
  curl -sL https://raw.githubusercontent.com/epi052/feroxbuster/main/install-nix.sh \
    | bash -s -- "${HOME}/.local/bin" \
    && log "feroxbuster installed to ${HOME}/.local/bin" \
    || warn "Failed to install feroxbuster"
  else
    warn "feroxbuster already installed"
  fi

  log "Installing binary analysis tools..."
  sudo apt install -y radare2 binwalk strace ltrace

  log "Installing reverse engineering extras..."
  if ! sudo apt install -y rizin 2>/dev/null; then
    warn "rizin not in apt - installing via GitHub release..."
    RIZIN_URL=$(wget -qO- https://api.github.com/repos/rizinorg/rizin/releases/latest \
      2>/dev/null | grep "browser_download_url.*amd64.deb" | head -1 | cut -d '"' -f 4) || true
    if [ -n "${RIZIN_URL:-}" ]; then
      wget -q --show-progress -O /tmp/rizin.deb "${RIZIN_URL}" \
        && sudo dpkg -i /tmp/rizin.deb \
        && sudo apt install -f -y \
        && rm -f /tmp/rizin.deb \
        && log "rizin installed" \
        || { warn "Failed to install rizin"; rm -f /tmp/rizin.deb; true; }
    else
      warn "Could not find rizin .deb download URL - install manually from https://github.com/rizinorg/rizin/releases"
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
      CUTTER_URL=$(wget -qO- https://api.github.com/repos/rizinorg/cutter/releases/latest \
        2>/dev/null | grep "browser_download_url.*AppImage" | grep -v ".zsync" | head -1 \
        | cut -d '"' -f 4) || true
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

  log "Installing forensics tools..."
  sudo apt install -y foremost scalpel libimage-exiftool-perl steghide outguess gddrescue ruby ruby-dev build-essential

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
  for pkg in pdfcrack; do
    install_package "$pkg"
  done

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
    curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > /tmp/msfinstall \
      && chmod +x /tmp/msfinstall \
      && sudo /tmp/msfinstall \
      && rm -f /tmp/msfinstall \
      && log "Metasploit installed" \
      || warn "Failed to install Metasploit"
  else
    warn "Metasploit already installed"
  fi

  warn "sagemath requires manual install - use https://sagecell.sagemath.org for quick crypto or install locally via: conda install sage -c conda-forge"


  log "Installing checksec..."
  if ! sudo apt install -y checksec 2>/dev/null; then
    warn "checksec not in apt - trying pip3..."
    command -v pip3 >/dev/null 2>&1 || sudo apt install -y python3-pip
    pip3 install checksec.sh --break-system-packages || warn "Failed to install checksec"
  fi

  log "Installing zsteg..."
  sudo gem install zsteg || warn "Failed to install zsteg via gem"

  log "Installing one_gadget via gem..."
  sudo gem install one_gadget || warn "Failed to install one_gadget via gem"

  log "Installing ROPgadget..."
  command -v pip3 >/dev/null 2>&1 || sudo apt install -y python3-pip
  pip3 install ROPgadget --break-system-packages || warn "Failed to install ROPgadget"

  log "Installing xortool..."
  command -v pip3 >/dev/null 2>&1 || sudo apt install -y python3-pip
  pip3 install xortool --break-system-packages || warn "Failed to install xortool"

  # --- pwndbg ---
  if [ "${INSTALL_PWNDDBG}" = true ]; then
    log "Installing pwndbg..."
    if [ -d "${TOOLS_DIR}/pwndbg" ]; then
      warn "pwndbg directory already exists, skipping clone"
    else
      git clone https://github.com/pwndbg/pwndbg "${TOOLS_DIR}/pwndbg" || warn "Failed to clone pwndbg"
    fi
    if [ -d "${TOOLS_DIR}/pwndbg" ]; then
      cd "${TOOLS_DIR}/pwndbg"
      bash setup.sh || warn "pwndbg setup.sh failed"
      cd -
      log "pwndbg installed"
    fi
  else
    warn "Skipping pwndbg (--no-pwndbg flag set)"
  fi

  if [ "${INSTALL_GHIDRA}" = true ]; then
    log "Installing Ghidra ${GHIDRA_VERSION}..."
    GHIDRA_EXISTING=$(find "${TOOLS_DIR}" -maxdepth 1 -type d -name 'ghidra_*' | head -1)
    if [ -n "${GHIDRA_EXISTING}" ]; then
      warn "Ghidra already exists at ${GHIDRA_EXISTING}, skipping download"
    elif command -v ghidraRun >/dev/null 2>&1; then
      warn "Ghidra command already available, skipping"
    else
      sudo apt install -y default-jdk || warn "Failed to install JDK (required for Ghidra)"
      wget -q --show-progress -O "/tmp/${GHIDRA_ZIP}" "${GHIDRA_URL}" || warn "Failed to download Ghidra"
      if [ -f "/tmp/${GHIDRA_ZIP}" ]; then
        unzip -q "/tmp/${GHIDRA_ZIP}" -d "${TOOLS_DIR}/" || warn "Failed to unzip Ghidra"
        rm -f "/tmp/${GHIDRA_ZIP}"
        log "Ghidra extracted to ${TOOLS_DIR}"
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
for cmd in nmap binwalk radare2 hashcat john jq zsteg ffuf feroxbuster fcrackzip smbclient zbarimg mat2 ROPgadget xortool msfconsole; do
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

Excluded (already in Ubuntu):
 - curl, wget, netcat, git, vim, gcc, gdb, file, xxd, binutils
 - tree, htop, unzip, openssl, gnupg, python3

EOF

log "Done — CTF tools installed!"