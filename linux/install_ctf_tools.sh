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

  log "Installing web/enumeration tools..."
  install_package dirb
  install_package gobuster
  install_package wfuzz
  install_package sqlmap
  install_package nikto
  warn "burpsuite not available in apt - install manually from https://portswigger.net/burp/communitydownload"

  log "Installing networking tools..."
  sudo apt install -y nmap tcpdump wireshark tshark

  log "Installing binary analysis tools..."
  sudo apt install -y radare2 binwalk strace ltrace

  log "Installing forensics tools..."
  sudo apt install -y foremost scalpel libimage-exiftool-perl steghide outguess gddrescue ruby ruby-dev build-essential
  install_package testdisk
  install_package sleuthkit
  install_package autopsy
  
  log "Installing zsteg..."
  sudo gem install zsteg || warn "Failed to install zsteg via gem"

  log "Installing media analysis tools..."
  sudo apt install -y ffmpeg mediainfo sox imagemagick

  log "Installing system monitoring tools..."
  sudo apt install -y tmux p7zip-full iotop sysstat lsof linux-tools-generic valgrind

  log "Installing password cracking tools..."
  sudo apt install -y hashcat john hydra

  log "Installing text processing tools..."
  sudo apt install -y jq xmlstarlet pandoc

  log "Installing security auditing tools..."
  install_package chkrootkit
  install_package rkhunter
  install_package lynis
  install_package aide
fi

log "APT install finished."

mkdir -p "${TOOLS_DIR}"
log "Tools directory: ${TOOLS_DIR}"

log "Verifying installed commands..."
for cmd in nmap binwalk radare2 hashcat john jq zsteg; do
  if command -v "${cmd}" >/dev/null 2>&1; then
    printf '  %-12s: installed\n' "${cmd}"
  else
    warn "Command '${cmd}' not found"
  fi
done

cat <<'EOF'

=====================================================================
Installation complete.

Manual steps required:
 - Install burpsuite from: https://portswigger.net/burp/communitydownload
 - Install Python tools in virtual environment:
   python3 -m venv ctf_env
   source ctf_env/bin/activate
   pip install pwntools requests beautifulsoup4 scapy cryptography volatility3

Excluded (already in Ubuntu):
 - curl, wget, netcat, git, vim, gcc, gdb, file, xxd, binutils
 - tree, htop, unzip, openssl, gnupg, python3

EOF

log "Done — CTF tools installed!"