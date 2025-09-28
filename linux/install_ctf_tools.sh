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
  # Core tools not in default Ubuntu
  sudo apt install -y \
    nmap tcpdump \
    binwalk strace ltrace radare2 \
    hashcat john \
    tmux p7zip-full
else
  log "Installing FULL package set..."

  # Web / enumeration tools
  log "Installing web/enumeration tools..."
  install_package dirb
  install_package gobuster
  install_package wfuzz
  install_package sqlmap
  install_package nikto
  # burpsuite - manual install required
  warn "burpsuite not available in apt - install manually from https://portswigger.net/burp/communitydownload"

  # Networking tools
  log "Installing networking tools..."
  sudo apt install -y nmap tcpdump wireshark tshark
  # curl, wget, netcat-openbsd, net-tools, iproute2 - already in Ubuntu

  # Binary analysis tools
  log "Installing binary analysis tools..."
  sudo apt install -y radare2 binwalk strace ltrace
  # gdb, file, xxd, binutils - already in Ubuntu
  # gcc, g++, make, cmake, git, vim - already in Ubuntu

  # Forensics tools
  log "Installing forensics tools..."
  sudo apt install -y foremost scalpel libimage-exiftool-perl steghide outguess gddrescue
  install_package testdisk
  install_package photorec
  install_package sleuthkit
  install_package autopsy

  # Media analysis
  log "Installing media analysis tools..."
  sudo apt install -y ffmpeg mediainfo sox imagemagick

  # System monitoring
  log "Installing system monitoring tools..."
  sudo apt install -y tmux p7zip-full iotop sysstat lsof linux-tools-generic valgrind
  # tree, htop, unzip - already in Ubuntu

  # Password cracking
  log "Installing password cracking tools..."
  sudo apt install -y hashcat john hydra

  # Crypto tools
  log "Installing crypto tools..."
  # openssl, gnupg - already in Ubuntu

  # Text processors
  log "Installing text processing tools..."
  sudo apt install -y jq xmlstarlet pandoc

  # Security auditing
  log "Installing security auditing tools..."
  install_package chkrootkit
  install_package rkhunter
  install_package lynis
  install_package aide

  # Runtime
  # python3, python3-pip, python3-dev, python3-venv, default-jre - already in Ubuntu or manual install
fi

log "APT install finished."

# Python tools - COMMENTED OUT (install manually in venv)
# log "Python tools to install manually in virtual environment:"
# warn "pip install pwntools requests beautifulsoup4 scapy cryptography volatility3"

# --- Tools directory ---
mkdir -p "${TOOLS_DIR}"
log "Tools directory: ${TOOLS_DIR}"

# --- GHIDRA (optional download) ---
# if [ "${INSTALL_GHIDRA}" = true ] && [ "${MINIMAL}" = false ]; then
#   log "Attempting to download GHIDRA (${GHIDRA_VERSION})..."
#   if command -v wget >/dev/null 2>&1; then
#     tmp_zip="$(mktemp --suffix=.zip)"
#     if wget -q -O "${tmp_zip}" "${GHIDRA_URL}"; then
#       unzip -q "${tmp_zip}" -d "${TOOLS_DIR}" || warn "Unzip failed"
#       rm -f "${tmp_zip}"
#       log "Ghidra downloaded and extracted to ${TOOLS_DIR}."
#     else
#       warn "Failed to download GHIDRA from ${GHIDRA_URL}"
#       rm -f "${tmp_zip}"
#     fi
#   else
#     warn "wget not available for GHIDRA download"
#   fi
# else
#   log "Skipping GHIDRA download"
# fi

# --- pwndbg (optional git clone) ---
# if [ "${INSTALL_PWNDDBG}" = true ]; then
#   log "Installing pwndbg..."
#   PWNDDBG_DIR="${TOOLS_DIR}/pwndbg"
#   if [ -d "${PWNDDBG_DIR}" ]; then
#     git -C "${PWNDDBG_DIR}" pull --ff-only || warn "Failed to update pwndbg"
#   else
#     git clone --depth 1 https://github.com/pwndbg/pwndbg "${PWNDDBG_DIR}" || warn "Failed to clone pwndbg"
#   fi
#   if [ -f "${PWNDDBG_DIR}/setup.sh" ]; then
#     (cd "${PWNDDBG_DIR}" && ./setup.sh) || warn "pwndbg setup failed"
#   fi
# else
#   log "Skipping pwndbg"
# fi

# --- Verification ---
log "Verifying installed commands..."
for cmd in nmap binwalk radare2 hashcat john jq; do
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