#!/bin/bash
# Script to install common CTF tools on a Linux system (Debian/Ubuntu based)
# Usage:
# chmod +x install_ctf_tools.sh
# ./install_ctf_tools.sh

# Update system
sudo apt update && sudo apt upgrade -y

# Web Exploitation
sudo apt install -y burpsuite dirb gobuster wfuzz sqlmap nikto

# General tools
sudo apt install -y curl wget nmap netcat-openbsd socat

# Binary/Reverse Engineering
sudo apt install -y gdb radare2 binwalk hexdump xxd strings file strace ltrace
sudo apt install -y gcc g++ make cmake git vim

# Forensics
sudo apt install -y foremost scalpel volatility-tools exiftool steghide outguess

# Cryptography
sudo apt install -y hashcat john openssl

# Python and libraries
sudo apt install -y python3 python3-pip python3-dev
pip3 install --user pwntools requests beautifulsoup4 scapy cryptography

# Additional useful tools
sudo apt install -y tree htop tmux unzip p7zip-full

# Install Ghidra (requires Java)
sudo apt install -y default-jre
wget https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_10.4_build/ghidra_10.4_PUBLIC_20230928.zip
unzip ghidra_10.4_PUBLIC_20230928.zip -d ~/tools/
rm ghidra_10.4_PUBLIC_20230928.zip

# Install pwndbg for GDB
git clone https://github.com/pwndbg/pwndbg
cd pwndbg
./setup.sh
cd ..

# Install CyberChef locally (optional)
# git clone https://github.com/gchq/CyberChef.git
# cd CyberChef
# npm install
# npm run build
# cd ..

echo "
# Web exploitation
sudo apt install burpsuite dirb gobuster wfuzz sqlmap

# Binary/reverse engineering  
sudo apt install gdb radare2 binwalk strings file

# Forensics
sudo apt install foremost volatility-tools exiftool steghide

# Crypto
sudo apt install hashcat john

# Python tools
pip3 install pwntools requests scapy cryptography
"
echo "====================================================================="
echo "Installation complete! Tools are ready for CTF challenges."
echo "Remember to add ~/.local/bin to your PATH if not already there."
