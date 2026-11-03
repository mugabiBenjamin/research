#!/usr/bin/env bash
# install_ctf_tools.sh
# Install CTF / forensics / RE / pentest / OSINT tools (excluding Ubuntu defaults)
# Usage:
#   chmod +x install_ctf_tools.sh
#   ./install_ctf_tools.sh [--no-ghidra] [--no-pwndbg] [--minimal]

set -uo pipefail
# NOTE: We intentionally omit -e (errexit) because many installs are optional
# and we prefer warn-and-continue over hard-abort. Critical failures use err().

# Configuration
TOOLS_DIR="${HOME}/tools"
OSINT_BIN="${HOME}/.local/bin"
MINIFORGE_DIR="${HOME}/miniforge3"
INSTALL_PWNDBG=true
INSTALL_GHIDRA=true
MINIMAL=false

# Helpers
log()  { printf '\e[1;32m[+] %s\e[0m\n' "$*"; }
warn() { printf '\e[1;33m[!] %s\e[0m\n' "$*"; }
err()  { printf '\e[1;31m[-] %s\e[0m\n' "$*"; exit 1; }

# Cleanup trap — remove temp files if the script is interrupted
CLEANUP_FILES=()
cleanup() {
  for f in "${CLEANUP_FILES[@]:-}"; do
    [ -f "$f" ] && rm -f "$f" && log "Cleaned up $f"
  done
}
trap cleanup EXIT INT TERM

register_tmp() { CLEANUP_FILES+=("$1"); }

# Fetch the first matching download URL from a GitHub release
fetch_latest_github_release() {
  local repo="$1" pattern="$2" exclude="${3:-__NO_EXCLUDE__}"
  local result
  result=$(wget -qO- "https://api.github.com/repos/${repo}/releases/latest" \
    2>/dev/null \
    | grep '"browser_download_url"' \
    | grep -i "${pattern}" \
    | grep -v "${exclude}" \
    | head -1 \
    | cut -d '"' -f 4) || true
  printf '%s' "${result}"
}

# apt install with a warn on failure (non-fatal)
install_package() {
  local pkg="$1"
  if sudo apt install -y "$pkg" 2>/dev/null; then
    log "apt: $pkg installed"
  else
    warn "apt: failed to install $pkg — package may not be available"
  fi
}

# idempotency guard: run block only if the command is missing
ensure_cmd() {
  local cmd="$1"; shift
  if command -v "$cmd" >/dev/null 2>&1; then
    warn "$cmd already installed — skipping"
    return 0
  fi
  "$@"
}

# Add a line to both ~/.bashrc and ~/.zshrc if not already present
persist_line() {
  local marker="$1" line="$2"
  for rc in ~/.bashrc ~/.zshrc; do
    [ -f "$rc" ] || continue
    if ! grep -qF "$marker" "$rc" 2>/dev/null; then
      printf '\n%s\n' "$line" >> "$rc"
      log "Added to $rc: $line"
    else
      warn "$marker already in $rc — skipping"
    fi
  done
}

# Flag parsing
for arg in "$@"; do
  case "$arg" in
    --no-ghidra) INSTALL_GHIDRA=false ;;
    --no-pwndbg) INSTALL_PWNDBG=false ;;
    --minimal)   MINIMAL=true ;;
    *) warn "Unknown flag: $arg" ;;
  esac
done

# Preflight checks
command -v sudo >/dev/null 2>&1 || err "sudo is required but not found."

if [ ! -f /etc/debian_version ]; then
  warn "This script targets Debian/Ubuntu. Proceeding anyway..."
fi

mkdir -p "${TOOLS_DIR}" "${OSINT_BIN}"

# Ensure ~/.local/bin is in PATH for this session and persisted
case ":${PATH}:" in
  *":${OSINT_BIN}:"*) ;;
  *) export PATH="${OSINT_BIN}:${PATH}" ;;
esac
persist_line 'HOME/.local/bin' 'export PATH="${HOME}/.local/bin:${PATH}"'

export DEBIAN_FRONTEND=noninteractive

# Bootstrap: base packages
log "Updating package lists..."
sudo apt update -y
log "Upgrading packages..."
sudo apt upgrade -y

log "Installing bootstrap dependencies..."
for pkg in \
  wget unzip curl git bubblewrap build-essential \
  vim binutils htop gnupg tree plocate make \
  python3-venv python3-dev libxml2-dev libxslt1-dev \
  libffi-dev libssl-dev libxslt-dev; do
  command -v "${pkg%%-*}" >/dev/null 2>&1 || sudo apt install -y "$pkg"
done

# Package manager: Homebrew
source_brew() {
  if [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  elif [ -x "${HOME}/.linuxbrew/bin/brew" ]; then
    eval "$("${HOME}/.linuxbrew/bin/brew" shellenv)"
  fi
}

# Resolve the brew binary path for RC persistence (not hardcoded)
brew_rc_line() {
  if [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"'
  elif [ -x "${HOME}/.linuxbrew/bin/brew" ]; then
    echo 'eval "$(${HOME}/.linuxbrew/bin/brew shellenv)"'
  fi
}

log "Setting up Homebrew..."
if ! command -v brew >/dev/null 2>&1; then
  NONINTERACTIVE=1 /bin/bash -c \
    "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  source_brew
  # Persist using the actual resolved path, not a hardcoded one
  brew_line=$(brew_rc_line)
  if [ -n "${brew_line}" ]; then
    persist_line 'brew shellenv' "${brew_line}"
    eval "${brew_line}"
  fi
  command -v brew >/dev/null 2>&1 \
    && log "Homebrew installed and in PATH" \
    || warn "Homebrew installed but not yet in PATH — subsequent brew installs may fail"
else
  warn "Homebrew already installed"
  source_brew
fi

brew_install() {
  local pkg="$1"
  if ! command -v brew >/dev/null 2>&1; then
    warn "brew not available; skipping $pkg"
    return
  fi
  if brew list --formula "$pkg" &>/dev/null; then
    warn "brew: $pkg already installed — upgrading..."
    brew upgrade "$pkg" 2>/dev/null || true
  else
    brew install "$pkg" && log "brew: $pkg installed" || warn "brew: failed to install $pkg"
  fi
}

# Package manager: Rust / Cargo
log "Setting up Rust (rustup)..."
if ! command -v cargo >/dev/null 2>&1; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \
    | sh -s -- -y --no-modify-path
  log "Rust installed"
else
  log "Rust already present — updating..."
  rustup update stable
fi

# Source cargo env for this session
# shellcheck source=/dev/null
[ -f "${HOME}/.cargo/env" ] && source "${HOME}/.cargo/env"
export PATH="${HOME}/.cargo/bin:${PATH}"
persist_line 'cargo/env' ". \"${HOME}/.cargo/env\""

cargo_install() {
  local pkg="$1"
  if ! command -v cargo >/dev/null 2>&1; then
    warn "cargo not available; skipping $pkg"
    return
  fi
  cargo install "$pkg" --locked \
    && log "cargo: $pkg installed/updated" \
    || warn "cargo: failed to install $pkg"
}

# Package manager: Go
log "Setting up Go (latest)..."

install_go() {
  local version
  version=$(curl -fsSL "https://go.dev/VERSION?m=text" | head -1) || true
  if [ -z "${version:-}" ]; then
    warn "Could not resolve latest Go version — skipping Go install"
    return
  fi

  local latest_url="https://go.dev/dl/${version}.linux-amd64.tar.gz"
  local installed_version=""
  [ -x /usr/local/go/bin/go ] \
    && installed_version=$(/usr/local/go/bin/go version 2>/dev/null | awk '{print $3}')

  if [ "${installed_version:-}" = "${version}" ]; then
    warn "Go ${version} already installed — skipping"
  else
    log "Installing Go ${version}..."
    local tmp_go="/tmp/go.tar.gz"
    register_tmp "${tmp_go}"
    wget -q --show-progress -O "${tmp_go}" "${latest_url}" \
      && sudo rm -rf /usr/local/go \
      && sudo tar -C /usr/local -xzf "${tmp_go}" \
      && rm -f "${tmp_go}" \
      && log "Go ${version} installed" \
      || warn "Failed to install Go"
  fi

  # Activate for current session regardless
  export PATH="/usr/local/go/bin:$(go env GOPATH 2>/dev/null || echo "${HOME}/go")/bin:${PATH}"
}

install_go

# Persist Go PATH — placed BEFORE miniforge so Go tools (e.g. httpx) take priority
# over same-named mamba/pip tools
persist_line '/usr/local/go/bin' \
  'export PATH="/usr/local/go/bin:$(go env GOPATH)/bin:${PATH}"'

go_install() {
  local pkg="$1"
  if ! command -v go >/dev/null 2>&1; then
    warn "go not available; skipping $pkg"
    return
  fi
  go install "${pkg}@latest" \
    && log "go install: $pkg done" \
    || warn "go install: failed for $pkg"
}

# Package manager: Mamba (Miniforge)
log "Setting up Mamba (Miniforge)..."

install_mamba() {
  local installer_url
  installer_url=$(curl -fsSL \
    "https://api.github.com/repos/conda-forge/miniforge/releases/latest" \
    | grep '"browser_download_url"' \
    | grep -i 'Linux-x86_64\.sh' \
    | head -1 \
    | cut -d '"' -f 4)
  if [ -z "${installer_url:-}" ]; then
    warn "Could not resolve Miniforge installer URL — skipping"
    return
  fi
  local tmp_mamba="/tmp/miniforge.sh"
  register_tmp "${tmp_mamba}"
  wget -q --show-progress -O "${tmp_mamba}" "${installer_url}" \
    && bash "${tmp_mamba}" -b -u -p "${MINIFORGE_DIR}" \
    && rm -f "${tmp_mamba}" \
    && log "Mamba installed at ${MINIFORGE_DIR}" \
    || warn "Failed to install Mamba"
}

if [ -x "${MINIFORGE_DIR}/bin/mamba" ]; then
  log "Mamba already installed — updating..."
  "${MINIFORGE_DIR}/bin/mamba" update -n base -c conda-forge mamba -y \
    || warn "Mamba update failed"
else
  install_mamba
fi

export PATH="${MINIFORGE_DIR}/bin:${PATH}"

# NOTE: Mamba PATH is persisted AFTER Go so Go tools shadow same-named mamba tools
persist_line 'miniforge3/bin' \
  "export PATH=\"${MINIFORGE_DIR}/bin:\${PATH}\""

mamba_install() {
  local pkg="$1" channel="${2:-conda-forge}"
  if ! command -v mamba >/dev/null 2>&1; then
    warn "mamba not available; skipping $pkg"
    return
  fi
  mamba install -n base -c "${channel}" -y "$pkg" \
    && log "mamba: $pkg installed/updated" \
    || warn "mamba: failed to install $pkg"
}

# Package manager: Ruby / Gem
ensure_gem() {
  if ! command -v gem >/dev/null 2>&1; then
    sudo apt install -y ruby ruby-dev build-essential
  fi
}

gem_install() {
  local pkg="$1"
  ensure_gem
  # Use --user-install to avoid conflicts with the system Ruby on Ubuntu 24.04
  gem install --user-install "$pkg" \
    && log "gem: $pkg installed/updated" \
    || warn "gem: failed to install $pkg"
}

# Ensure gem user bin dir is in PATH
GEM_USER_BIN="$(ruby -e 'puts Gem.user_dir' 2>/dev/null)/bin" || GEM_USER_BIN=""
if [ -n "${GEM_USER_BIN}" ]; then
  export PATH="${GEM_USER_BIN}:${PATH}"
  persist_line 'gem user_dir' \
    'export PATH="$(ruby -e '"'"'puts Gem.user_dir'"'"')/bin:${PATH}"'
fi

# uv (fast Python package / project manager — required by theHarvester)
log "Installing uv..."
if ! command -v uv >/dev/null 2>&1; then
  curl -LsSf https://astral.sh/uv/install.sh | sh \
    && export PATH="${HOME}/.cargo/bin:${PATH}" \
    && log "uv installed" \
    || warn "Failed to install uv"
else
  warn "uv already installed"
fi

# MINIMAL MODE
if [ "${MINIMAL}" = true ]; then
  log "Installing MINIMAL package set..."
  sudo apt install -y nmap tcpdump binwalk strace ltrace radare2 hashcat john tmux p7zip-full ruby ruby-dev build-essential

  gem_install zsteg
  log "Minimal install complete."
  exit 0
fi

# FULL MODE
# Phase 1: Networking & Scanning
log "=== Phase 1: Networking & Scanning ==="

log "Installing core network tools..."
sudo apt install -y nmap tcpdump wireshark tshark

log "Configuring Wireshark for non-root capture..."
echo "wireshark-common wireshark-common/install-setuid boolean true" \
  | sudo debconf-set-selections
sudo DEBIAN_FRONTEND=noninteractive dpkg-reconfigure -f noninteractive wireshark-common
sudo usermod -aG wireshark "$USER"

log "Installing masscan..."
ensure_cmd masscan sudo apt install -y masscan \
  || warn "Failed to install masscan"

log "Installing RustScan..."
ensure_cmd rustscan brew_install rustscan

log "Installing Naabu..."
ensure_cmd naabu go_install github.com/projectdiscovery/naabu/v2/cmd/naabu

log "Installing Amass..."
ensure_cmd amass brew_install amass

log "Installing SMB / Windows enumeration tools..."
sudo apt install -y smbclient

# Phase 2: Web Enumeration & Fuzzing
log "=== Phase 2: Web Enumeration & Fuzzing ==="

log "Installing ffuf..."
sudo apt install -y ffuf

log "Installing feroxbuster..."
if ! command -v feroxbuster >/dev/null 2>&1; then
  local_ferox_script="/tmp/ferox-install.sh"
  register_tmp "${local_ferox_script}"
  curl -fsSL https://raw.githubusercontent.com/epi052/feroxbuster/main/install-nix.sh \
    -o "${local_ferox_script}" \
    && chmod +x "${local_ferox_script}" \
    && bash "${local_ferox_script}" "${OSINT_BIN}" \
    && rm -f "${local_ferox_script}" \
    && log "feroxbuster installed to ${OSINT_BIN}" \
    || { warn "Failed to install feroxbuster"; rm -f "${local_ferox_script}"; }
else
  warn "feroxbuster already installed — skipping"
fi

log "Installing subfinder..."
ensure_cmd subfinder \
  go_install github.com/projectdiscovery/subfinder/v2/cmd/subfinder

log "Installing httpx (projectdiscovery)..."
# Go's httpx installs to GOPATH/bin and takes priority over mamba's httpx
# due to PATH ordering set above
ensure_cmd httpx go_install github.com/projectdiscovery/httpx/cmd/httpx

log "Installing nuclei..."
ensure_cmd nuclei go_install github.com/projectdiscovery/nuclei/v3/cmd/nuclei

log "Installing dnsx..."
ensure_cmd dnsx go_install github.com/projectdiscovery/dnsx/cmd/dnsx

log "Installing katana..."
ensure_cmd katana go_install github.com/projectdiscovery/katana/cmd/katana

log "Installing kiterunner..."
if command -v kr >/dev/null 2>&1; then
  warn "kiterunner (kr) already installed — skipping"
elif [ -d "${TOOLS_DIR}/kiterunner" ]; then
  warn "kiterunner source already cloned — attempting rebuild..."
  make -C "${TOOLS_DIR}/kiterunner" build \
    && sudo ln -sf "${TOOLS_DIR}/kiterunner/dist/kr" /usr/local/bin/kr \
    || warn "kiterunner rebuild failed"
else
  git clone https://github.com/assetnote/kiterunner.git "${TOOLS_DIR}/kiterunner" \
    && make -C "${TOOLS_DIR}/kiterunner" build \
    && sudo ln -sf "${TOOLS_DIR}/kiterunner/dist/kr" /usr/local/bin/kr \
    && log "kiterunner installed" \
    || warn "Failed to install kiterunner"
fi

log "Installing optional web/enumeration tools..."
for pkg in dirb gobuster wfuzz sqlmap nikto; do
  install_package "$pkg"
done

# Phase 3: Recon & OSINT
log "=== Phase 3: Recon & OSINT ==="

# ── theHarvester ─────────────────────────────────────────────
log "Installing theHarvester..."
if [ ! -d "${TOOLS_DIR}/theHarvester" ]; then
  git clone https://github.com/laramies/theHarvester.git \
    "${TOOLS_DIR}/theHarvester" \
    || warn "Failed to clone theHarvester"
fi
if [ -d "${TOOLS_DIR}/theHarvester" ]; then
  if command -v uv >/dev/null 2>&1; then
    (
      cd "${TOOLS_DIR}/theHarvester"
      uv sync
    ) && {
      sudo ln -sf "${TOOLS_DIR}/theHarvester/.venv/bin/theHarvester" \
        /usr/local/bin/theHarvester \
        && log "theHarvester installed"
    } || warn "theHarvester: uv sync failed"
  else
    warn "uv not available — theHarvester requires uv; install it first"
  fi
fi

# ── SpiderFoot ────────────────────────────────────────────────
sudo apt install -y python3.12 python3.12-venv 2>/dev/null \
  || warn "python3.12 not available — SpiderFoot venv will use system python3"

log "Installing SpiderFoot..."
SPIDERFOOT_DIR="${TOOLS_DIR}/spiderfoot"
if [ ! -d "${SPIDERFOOT_DIR}/.git" ]; then
  git clone https://github.com/smicallef/spiderfoot.git "${SPIDERFOOT_DIR}" \
    || warn "Failed to clone SpiderFoot"
else
  git -C "${SPIDERFOOT_DIR}" pull || warn "Failed to update SpiderFoot"
fi
if [ -f "${SPIDERFOOT_DIR}/requirements.txt" ]; then
  (
    cd "${SPIDERFOOT_DIR}"
    python3 -m venv .venv
    .venv/bin/python -m pip install --upgrade pip
    .venv/bin/python -m pip install "lxml>=4.9.2" --only-binary=:all: --no-cache-dir || \
      warn "lxml binary wheel failed — SpiderFoot XML features may be broken"
    sed -i 's/lxml<5,>=4\.9\.2/lxml>=4.9.2/' requirements.txt
    sed -i '/^lxml/d' requirements.txt
    .venv/bin/python -m pip install -r requirements.txt --no-build-isolation
  ) && {
    cat > "${OSINT_BIN}/spiderfoot" <<EOF
#!/usr/bin/env bash
exec "${SPIDERFOOT_DIR}/.venv/bin/python" "${SPIDERFOOT_DIR}/sf.py" "\$@"
EOF
    chmod +x "${OSINT_BIN}/spiderfoot"
    log "SpiderFoot installed (${OSINT_BIN}/spiderfoot)"
  } || warn "SpiderFoot: pip install failed"
fi

# ── Recon-ng ──────────────────────────────────────────────────
log "Installing Recon-ng..."
RECONNG_DIR="${TOOLS_DIR}/recon-ng"
if [ ! -d "${RECONNG_DIR}/.git" ]; then
  git clone https://github.com/lanmaster53/recon-ng.git "${RECONNG_DIR}" \
    || warn "Failed to clone Recon-ng"
else
  git -C "${RECONNG_DIR}" pull || warn "Failed to update Recon-ng"
fi
if [ -f "${RECONNG_DIR}/REQUIREMENTS" ]; then
  (
    cd "${RECONNG_DIR}"
    python3 -m venv .venv
    .venv/bin/python -m pip install --upgrade pip
    .venv/bin/python -m pip install -r REQUIREMENTS
  ) && {
    cat > "${OSINT_BIN}/recon-ng" <<EOF
#!/usr/bin/env bash
exec "${RECONNG_DIR}/.venv/bin/python" "${RECONNG_DIR}/recon-ng" "\$@"
EOF
    chmod +x "${OSINT_BIN}/recon-ng"
    log "Recon-ng installed (${OSINT_BIN}/recon-ng)"
  } || warn "Recon-ng: pip install failed"
fi

# ── Sherlock ──────────────────────────────────────────────────
log "Installing Sherlock..."
SHERLOCK_DIR="${TOOLS_DIR}/sherlock"
if [ ! -d "${SHERLOCK_DIR}/.git" ]; then
  git clone https://github.com/sherlock-project/sherlock.git "${SHERLOCK_DIR}" \
    || warn "Failed to clone Sherlock"
else
  git -C "${SHERLOCK_DIR}" pull || warn "Failed to update Sherlock"
fi
if [ -f "${SHERLOCK_DIR}/pyproject.toml" ]; then
  (
    cd "${SHERLOCK_DIR}"
    python3 -m venv .venv
    .venv/bin/python -m pip install --upgrade pip
    .venv/bin/python -m pip install .
  ) && {
    if [ -x "${SHERLOCK_DIR}/.venv/bin/sherlock" ]; then
      ln -sf "${SHERLOCK_DIR}/.venv/bin/sherlock" "${OSINT_BIN}/sherlock"
      log "Sherlock installed (${OSINT_BIN}/sherlock)"
    else
      warn "Sherlock executable was not created in .venv/bin"
    fi
  } || warn "Sherlock: pip install failed"
fi

# ── Maltego ───────────────────────────────────────────────────
log "Checking for Maltego installer..."
MALTEGO_DEB=""
if [ -d "${HOME}/Downloads" ]; then
  MALTEGO_DEB=$(find "${HOME}/Downloads" \
    -maxdepth 1 -type f -name 'Maltego*.deb' -print -quit 2>/dev/null || true)
fi
if [ -n "${MALTEGO_DEB}" ]; then
  sudo apt install -y "${MALTEGO_DEB}" \
    && log "Maltego installed from ${MALTEGO_DEB}" \
    || warn "Maltego: dpkg install failed"
elif command -v maltego >/dev/null 2>&1; then
  warn "Maltego already installed — skipping"
else
  warn "Maltego installer not found. Download from: https://www.maltego.com/downloads/"
  warn "Place Maltego*.deb in ~/Downloads and re-run this script, or run:"
  warn "  sudo apt install ~/Downloads/Maltego*.deb"
fi

# ── Go OSINT / recon helpers ──────────────────────────────────
log "Installing Go recon tools..."
ensure_cmd waybackurls go_install github.com/tomnomnom/waybackurls
ensure_cmd gf          go_install github.com/tomnomnom/gf
ensure_cmd anew        go_install github.com/tomnomnom/anew
ensure_cmd gau         go_install github.com/lc/gau/v2/cmd/gau
ensure_cmd hakrawler   go_install github.com/hakluke/hakrawler

# Phase 4: Binary Analysis & Reverse Engineering

log "=== Phase 4: Binary Analysis & Reverse Engineering ==="

log "Installing core binary analysis tools..."
sudo apt install -y radare2 binwalk strace ltrace upx-ucl ghex

log "Installing checksec..."
if ! sudo apt install -y checksec 2>/dev/null; then
  warn "checksec not in apt — installing via pip..."
  pip3 install checksec --break-system-packages 2>/dev/null \
    || warn "checksec pip install also failed; see: https://github.com/slimm609/checksec.sh"
fi

log "Installing rizin..."
if ! sudo apt install -y rizin 2>/dev/null; then
  warn "rizin not in apt — fetching .deb from GitHub..."
  RIZIN_URL=$(fetch_latest_github_release \
    "rizinorg/rizin" \
    "linux.*amd64\.deb" \
    "__NO_EXCLUDE__")
  if [ -n "${RIZIN_URL:-}" ]; then
    local_rizin="/tmp/rizin.deb"
    register_tmp "${local_rizin}"
    wget -q --show-progress -O "${local_rizin}" "${RIZIN_URL}" \
      && sudo dpkg -i "${local_rizin}" \
      && sudo apt install -f -y \
      && rm -f "${local_rizin}" \
      && log "rizin installed via .deb" \
      || { warn "Failed to install rizin; install manually from https://github.com/rizinorg/rizin/releases"; rm -f "${local_rizin}"; }
  else
    warn "Could not resolve rizin release URL; install manually from https://github.com/rizinorg/rizin/releases"
  fi
fi

log "Installing Cutter..."
if command -v cutter >/dev/null 2>&1; then
  warn "cutter already installed — skipping"
elif [ -f "${TOOLS_DIR}/cutter.AppImage" ]; then
  warn "cutter AppImage already present — re-linking..."
  chmod +x "${TOOLS_DIR}/cutter.AppImage"
  sudo ln -sf "${TOOLS_DIR}/cutter.AppImage" /usr/local/bin/cutter
else
  if ! sudo apt install -y cutter 2>/dev/null; then
    warn "cutter not in apt — fetching AppImage from GitHub..."
    CUTTER_URL=$(fetch_latest_github_release \
      "rizinorg/cutter" "AppImage" "\.zsync")
    if [ -n "${CUTTER_URL:-}" ]; then
      wget -q --show-progress -O "${TOOLS_DIR}/cutter.AppImage" "${CUTTER_URL}" \
        && chmod +x "${TOOLS_DIR}/cutter.AppImage" \
        && sudo ln -sf "${TOOLS_DIR}/cutter.AppImage" /usr/local/bin/cutter \
        && log "Cutter installed (${TOOLS_DIR}/cutter.AppImage)" \
        || warn "Failed to download Cutter AppImage"
    else
      warn "Could not resolve Cutter AppImage URL"
    fi
  fi
fi

# ── Ghidra ────────────────────────────────────────────────────
if [ "${INSTALL_GHIDRA}" = true ]; then
  log "Installing Ghidra (latest)..."
  GHIDRA_EXISTING=$(find "${TOOLS_DIR}" -maxdepth 1 -type d -name 'ghidra_*' | head -1)
  if [ -n "${GHIDRA_EXISTING}" ]; then
    warn "Ghidra already exists at ${GHIDRA_EXISTING} — skipping"
  elif command -v ghidraRun >/dev/null 2>&1; then
    warn "ghidraRun already in PATH — skipping"
  else
    # Match .zip files that contain "PUBLIC" in the name, exclude debug/source zips
    GHIDRA_URL=$(fetch_latest_github_release \
      "NationalSecurityAgency/ghidra" \
      "_PUBLIC.*\.zip" \
      "src\|debug")
    if [ -z "${GHIDRA_URL:-}" ]; then
      warn "Could not resolve Ghidra release URL — install manually from https://github.com/NationalSecurityAgency/ghidra/releases"
    else
      GHIDRA_ZIP=$(basename "${GHIDRA_URL}")
      local_ghidra="/tmp/${GHIDRA_ZIP}"
      register_tmp "${local_ghidra}"
      sudo apt install -y default-jdk \
        || warn "Failed to install JDK (required for Ghidra)"
      wget -q --show-progress -O "${local_ghidra}" "${GHIDRA_URL}" \
        && unzip -q "${local_ghidra}" -d "${TOOLS_DIR}/" \
        && rm -f "${local_ghidra}" \
        && log "Ghidra extracted to ${TOOLS_DIR}" \
        || { warn "Failed to download/unzip Ghidra"; rm -f "${local_ghidra}"; }

      # Create a convenience symlink to ghidraRun
      GHIDRA_NEW=$(find "${TOOLS_DIR}" -maxdepth 1 -type d -name 'ghidra_*' | head -1)
      if [ -n "${GHIDRA_NEW}" ] && [ -f "${GHIDRA_NEW}/ghidraRun" ]; then
        sudo ln -sf "${GHIDRA_NEW}/ghidraRun" /usr/local/bin/ghidraRun
        log "ghidraRun symlinked to /usr/local/bin/ghidraRun"
      fi
    fi
  fi
else
  warn "Skipping Ghidra (--no-ghidra)"
fi

# ── pwndbg ────────────────────────────────────────────────────
if [ "${INSTALL_PWNDBG}" = true ]; then
  log "Installing pwndbg..."
  if [ ! -d "${TOOLS_DIR}/pwndbg" ]; then
    git clone https://github.com/pwndbg/pwndbg "${TOOLS_DIR}/pwndbg" \
      || warn "Failed to clone pwndbg"
  else
    warn "pwndbg already cloned — pulling latest..."
    git -C "${TOOLS_DIR}/pwndbg" pull || warn "Failed to update pwndbg"
  fi
  if [ -d "${TOOLS_DIR}/pwndbg" ]; then
    ( cd "${TOOLS_DIR}/pwndbg" && bash setup.sh ) \
      && log "pwndbg installed" \
      || warn "pwndbg setup.sh failed"
  fi
else
  warn "Skipping pwndbg (--no-pwndbg)"
fi

# Phase 5: Forensics & Steganography
log "=== Phase 5: Forensics & Steganography ==="

log "Installing forensics tools..."
sudo apt install -y foremost scalpel libimage-exiftool-perl steghide gddrescue

log "Installing steganography extras..."
sudo apt install -y zbar-tools mat2

for pkg in stegseek sonic-visualiser; do
  install_package "$pkg"
done

log "Installing media analysis tools..."
sudo apt install -y ffmpeg mediainfo sox imagemagick

log "Installing optional forensics tools..."
for pkg in testdisk sleuthkit autopsy; do
  install_package "$pkg"
done

# Phase 6: Password Cracking
log "=== Phase 6: Password Cracking ==="

sudo apt install -y hashcat john hydra fcrackzip
install_package pdfcrack

# Phase 7: Exploitation Frameworks
log "=== Phase 7: Exploitation Frameworks ==="

log "Installing Metasploit Framework..."
if ! command -v msfconsole >/dev/null 2>&1; then
  local_msf="/tmp/msfinstall"
  register_tmp "${local_msf}"
  curl -fsSL \
    https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb \
    -o "${local_msf}" \
    && chmod +x "${local_msf}" \
    && sudo "${local_msf}" \
    && rm -f "${local_msf}" \
    && log "Metasploit installed" \
    || { warn "Failed to install Metasploit"; rm -f "${local_msf}"; }
else
  warn "Metasploit already installed — skipping"
fi

# Phase 8: Monitoring, Utilities & Text Processing
log "=== Phase 8: Utilities & Text Processing ==="

sudo apt install -y tmux p7zip-full iotop sysstat lsof valgrind jq xmlstarlet pandoc

install_package linux-tools-generic

log "Installing optional security auditing tools..."
for pkg in chkrootkit rkhunter lynis aide; do
  install_package "$pkg"
done

# Phase 9: Cargo tools
log "=== Phase 9: Cargo tools ==="

cargo_install ripgrep
cargo_install fd-find
cargo_install bat
cargo_install hexyl
cargo_install tokei
cargo_install rsacracker

# Phase 10: Mamba packages
log "=== Phase 10: Mamba packages ==="

mamba_install sage

# Phase 11: Gem tools
log "=== Phase 11: Gem tools ==="

gem_install zsteg
gem_install one_gadget


# Phase 12: BurpSuite notice
warn "BurpSuite not available in apt — install manually from https://portswigger.net/burp/communitydownload"

# Verification
log "=== Verification: checking installed commands ==="

# Only check commands that are actually installed by this script
VERIFY_CMDS=(
  # Bootstrap
  vim objdump htop gpg tree brew

  # Networking / scanning
  nmap tcpdump tshark rustscan naabu masscan amass subfinder smbclient

  # Web / fuzzing
  ffuf feroxbuster httpx nuclei dnsx katana kr
  dirb gobuster sqlmap nikto

  # Recon / OSINT
  waybackurls gau hakrawler gf anew spiderfoot recon-ng sherlock theHarvester

  # Binary analysis / RE
  radare2 binwalk upx ghex strace ltrace

  # Forensics
  foremost exiftool steghide zbarimg mat2 ffmpeg mediainfo sox

  # Password cracking
  hashcat john hydra fcrackzip

  # Exploitation
  msfconsole

  # Cargo
  cargo rustc rg fd bat hexyl tokei

  # Go / Mamba
  go mamba

  # Gem
  zsteg one_gadget

  # Utilities
  tmux jq pandoc uv
)

MISSING=()
for cmd in "${VERIFY_CMDS[@]}"; do
  if command -v "${cmd}" >/dev/null 2>&1; then
    printf '  \e[1;32m%-20s installed\e[0m\n' "${cmd}"
  else
    printf '  \e[1;33m%-20s NOT FOUND\e[0m\n' "${cmd}"
    MISSING+=("${cmd}")
  fi
done

if [ "${#MISSING[@]}" -gt 0 ]; then
  warn "The following commands were not found after install:"
  for m in "${MISSING[@]}"; do
    warn "  - ${m}"
  done
fi

# Manual steps
cat <<EOF

=====================================================================
Installation complete.
Tools directory: ${TOOLS_DIR}

Manual steps required:
 ── BurpSuite ────────────────────────────────────────────────────
   Download from: https://portswigger.net/burp/communitydownload

 ── JD-GUI (Java decompiler) ─────────────────────────────────────
   Download .jar from: https://github.com/java-decompiler/jd-gui/releases
   Run with: java -jar /path/to/jd-gui-<version>.jar

 ── tplmap (SSTI scanner) ────────────────────────────────────────
   git clone https://github.com/epinna/tplmap.git ${TOOLS_DIR}/tplmap
   pip3 install -r ${TOOLS_DIR}/tplmap/requirements.txt --break-system-packages
   sudo ln -s ${TOOLS_DIR}/tplmap/tplmap.py /usr/local/bin/tplmap
   chmod +x ${TOOLS_DIR}/tplmap/tplmap.py

 ── enum4linux-ng ────────────────────────────────────────────────
   git clone https://github.com/cddmp/enum4linux-ng.git ${TOOLS_DIR}/enum4linux-ng
   pip3 install -r ${TOOLS_DIR}/enum4linux-ng/requirements.txt --break-system-packages
   sudo ln -s ${TOOLS_DIR}/enum4linux-ng/enum4linux-ng.py /usr/local/bin/enum4linux-ng

 ── Responder ────────────────────────────────────────────────────
   git clone https://github.com/lgandx/Responder.git ${TOOLS_DIR}/Responder
   Run with: sudo python3 ${TOOLS_DIR}/Responder/Responder.py -I <interface>

 ── checksec (if apt install failed) ─────────────────────────────
   git clone https://github.com/slimm609/checksec.sh ${TOOLS_DIR}/checksec
   sudo ln -sf ${TOOLS_DIR}/checksec/checksec /usr/local/bin/checksec

 ── Mamba shell init (first time only) ───────────────────────────
   ${MINIFORGE_DIR}/bin/conda init bash   # or: conda init zsh
   # then restart your shell

 ── PATH ordering note ───────────────────────────────────────────
   Go PATH is persisted BEFORE miniforge in your RC files so that
   Go-installed tools (e.g. httpx) shadow same-named mamba/pip tools.
   If you added miniforge manually before running this script, move
   the Go PATH export above the miniforge export in ~/.bashrc / ~/.zshrc.

 ── Excluded (already in Ubuntu) ─────────────────────────────────
   curl, wget, netcat, git, gcc, gdb, file, xxd, openssl, gnupg, python3
=====================================================================
EOF

log "Done — CTF tools installed!"