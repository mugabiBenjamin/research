#!/usr/bin/env bash
# install_ctf_tools.sh
# Install a wide set of CTF / forensics / RE / pentest tools on Debian/Ubuntu systems.
# Usage:
#   chmod +x install_ctf_tools.sh
#   ./install_ctf_tools.sh [--no-ghidra] [--no-pwndbg] [--minimal]
# Notes:
#  - 'strings' comes from binutils.
#  - Volatility (volatility3) is installed via pip (not reliably in apt).
#  - GHIDRA install is optional. Change GHIDRA_VERSION to update.
set -euo pipefail

# --- Configuration ---
GHIDRA_VERSION="10.4_PUBLIC_20230928"   # change if you want another version
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

# Helper to install packages with error handling
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

# --- Package lists ---
if [ "${MINIMAL}" = true ]; then
  log "Installing MINIMAL package set..."
  sudo apt install -y \
    curl wget nmap netcat-openbsd tcpdump \
    gdb binwalk file strace ltrace xxd hexdump binutils \
    gcc g++ make cmake git vim \
    python3 python3-pip python3-venv \
    hashcat john \
    tree htop tmux unzip p7zip-full default-jre
else
  log "Installing FULL package set (may take a while)..."

  # Web / enumeration / scanners (install individually due to availability issues)
  log "Installing web/enumeration tools..."
  install_package dirb
  install_package gobuster
  install_package wfuzz
  install_package sqlmap
  install_package nikto
  warn "burpsuite not available in apt - install manually from https://portswigger.net/burp/communitydownload"

  # Networking / captures / utils
  log "Installing networking tools..."
  sudo apt install -y curl wget nmap netcat-openbsd tcpdump wireshark tshark net-tools iproute2

  # Binary / RE / build tools (xxd/hexdump/binutils included)
  log "Installing binary analysis tools..."
  sudo apt install -y gdb radare2 binwalk file strace ltrace xxd hexdump binutils
  sudo apt install -y gcc g++ make cmake git vim vim-common

  # Forensics / recovery
  log "Installing forensics tools..."
  sudo apt install -y foremost scalpel libimage-exiftool-perl steghide outguess gddrescue
  install_package testdisk
  install_package photorec
  install_package sleuthkit
  install_package autopsy

  # Media / analysis
  log "Installing media analysis tools..."
  sudo apt install -y ffmpeg mediainfo sox imagemagick

  # Monitoring / sysadmin
  log "Installing system monitoring tools..."
  sudo apt install -y tree htop tmux unzip p7zip-full iotop sysstat lsof perf valgrind

  # Security / password / cracking / brute
  log "Installing password cracking tools..."
  sudo apt install -y hashcat john hydra

  # Crypto / GPG / SSL
  log "Installing crypto tools..."
  sudo apt install -y openssl gnupg

  # Text / data processors
  log "Installing text processing tools..."
  sudo apt install -y jq xmlstarlet pandoc

  # Rootkit / auditing / integrity
  log "Installing security auditing tools..."
  install_package chkrootkit
  install_package rkhunter
  install_package lynis
  install_package aide

  # Python & runtime
  log "Installing Python runtime..."
  sudo apt install -y python3 python3-pip python3-dev python3-venv default-jre
fi

log "APT install finished."

# Ensure ~/.local/bin exists and warn if not in PATH
mkdir -p "${HOME}/.local/bin"
if ! echo "${PATH}" | tr ':' '\n' | grep -qx "${HOME}/.local/bin"; then
  warn "Add '${HOME}/.local/bin' to your PATH (e.g. add to ~/.profile or ~/.bashrc)."
fi

# --- Python tools (user) ---
log "Upgrading pip and installing Python tools (user)..."
python3 -m pip install --user --upgrade pip setuptools wheel

# Core python packages useful for CTF / forensics / RE
PY_PKGS=(pwntools requests beautifulsoup4 scapy cryptography volatility3)
for pkg in "${PY_PKGS[@]}"; do
  log "Installing ${pkg}..."
  python3 -m pip install --user "${pkg}" || warn "pip install ${pkg} failed (you may need to run it manually)."
done

log "Installed volatility3 via pip (if available)."

# --- Tools directory ---
mkdir -p "${TOOLS_DIR}"
log "Tools directory: ${TOOLS_DIR}"

# --- GHIDRA (optional) ---
if [ "${INSTALL_GHIDRA}" = true ] && [ "${MINIMAL}" = false ]; then
  log "Attempting to download and install GHIDRA (${GHIDRA_VERSION})..."
  if command -v wget >/dev/null 2>&1; then
    tmp_zip="$(mktemp --suffix=.zip)"
    if wget -q -O "${tmp_zip}" "${GHIDRA_URL}"; then
      unzip -q "${tmp_zip}" -d "${TOOLS_DIR}" || warn "Unzip failed; you may need to unzip manually."
      rm -f "${tmp_zip}"
      log "Ghidra downloaded and extracted to ${TOOLS_DIR}."
    else
      warn "Failed to download GHIDRA from ${GHIDRA_URL}. Check network or update GHIDRA_URL."
      rm -f "${tmp_zip}"
    fi
  else
    warn "wget not installed; cannot download GHIDRA automatically."
  fi
else
  log "Skipping GHIDRA (either --no-ghidra passed, or running MINIMAL install)."
fi

# --- pwndbg (optional) ---
if [ "${INSTALL_PWNDDBG}" = true ]; then
  log "Installing or updating pwndbg..."
  PWNDDBG_DIR="${TOOLS_DIR}/pwndbg"
  if [ -d "${PWNDDBG_DIR}" ]; then
    git -C "${PWNDDBG_DIR}" pull --ff-only || warn "Failed to update pwndbg; please update manually."
  else
    git clone --depth 1 https://github.com/pwndbg/pwndbg "${PWNDDBG_DIR}" || warn "Failed to clone pwndbg."
  fi
  if [ -f "${PWNDDBG_DIR}/setup.sh" ]; then
    (cd "${PWNDDBG_DIR}" && ./setup.sh) || warn "pwndbg setup script failed; run manually if needed."
  fi
else
  log "Skipping pwndbg as requested."
fi

# --- Post-install notes & small sanity checks ---
log "Verifying a few installed commands..."
for cmd in strings binwalk gdb nmap python3 pip3 jq; do
  if command -v "${cmd}" >/dev/null 2>&1; then
    printf '  %-12s: %s\n' "${cmd}" "$(command -v ${cmd})"
  else
    warn "Command '${cmd}' not found in PATH (install may have failed or PATH needs update)."
  fi
done

cat <<'EOF'

=====================================================================
Installation steps finished.

Quick reminders:
 - 'strings' is provided by binutils; there is no separate 'strings' apt package.
 - 'volatility-tools' is often not available in apt. We installed volatility3 via pip (python3 -m pip install --user volatility3).
 - GHIDRA download uses GHIDRA_URL at top; change GHIDRA_VERSION/GHIDRA_URL to update the version. For the absolute latest GHIDRA automatically you'd need to query GitHub (not implemented here).
 - burpsuite must be installed manually from https://portswigger.net/burp/communitydownload
 - Add ~/.local/bin to PATH if missing:
     echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.profile
 - If a specific tool failed to install, run the corresponding apt or pip command shown above manually or check the warnings printed.

To run script again with minimal set:
  ./install_ctf_tools.sh --minimal

To skip GHIDRA or pwndbg:
  ./install_ctf_tools.sh --no-ghidra --no-pwndbg

EOF

log "Done — tools installed (or attempted). Good luck with your CTFs!"