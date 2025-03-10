#!/bin/bash
# Enhanced Ubuntu System Update Script
# 
# Instructions:
# 1. Save this file as "update.sh"
# 2. Make it executable: chmod +x update.sh
# 3. Run with sudo privileges: sudo ./update.sh

# Set script to exit immediately if a command fails
set -e

# Define colors for better output readability
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
NC="\033[0m" # No Color

# Function to display section headers
print_section() {
    echo -e "\n${YELLOW}$1${NC}"
    echo -e "${YELLOW}$(printf '=%.0s' {1..50})${NC}"
}

# Function to execute commands with error handling
execute_cmd() {
    echo -e "${GREEN}> $1${NC}"
    if eval "$1"; then
        return 0
    else
        echo -e "${RED}Command failed: $1${NC}"
        return 1
    fi
}

# Check if script is run with sudo privileges
if [ "$(id -u)" -ne 0 ]; then
    echo -e "${RED}Error: This script must be run with sudo privileges.${NC}"
    echo "Please run: sudo $0"
    exit 1
fi

# Create a log file with timestamp
LOG_FILE="/var/log/system-update-$(date +%Y%m%d-%H%M%S).log"
exec > >(tee -i $LOG_FILE)
exec 2>&1

print_section "Starting System Update and Maintenance"
echo "Date: $(date)"
echo "Ubuntu Version: $(lsb_release -ds)"
echo "Kernel Version: $(uname -r)"

# Update package lists
print_section "Updating Package Lists"
execute_cmd "apt update -y"

# Check if reboot is required before starting
if [ -f /var/run/reboot-required ]; then
    echo -e "${YELLOW}A system reboot is required before proceeding.${NC}"
    read -p "Would you like to reboot now? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "System will reboot now..."
        reboot
        exit 0
    fi
fi

# Upgrade packages
print_section "Upgrading Installed Packages"
execute_cmd "apt upgrade -y"
execute_cmd "apt full-upgrade -y"

# Clean up unused packages
print_section "Cleaning Up Unused Packages"
execute_cmd "apt autoremove --purge -y"
execute_cmd "apt autoclean -y"

# Check if system uses snap
if command -v snap &> /dev/null; then
    print_section "Updating Snap Packages"
    execute_cmd "snap refresh"
fi

# Check if system uses flatpak
if command -v flatpak &> /dev/null; then
    print_section "Updating Flatpak Packages"
    execute_cmd "flatpak update -y"
fi

# Check if firmware update utility is installed
if command -v fwupdmgr &> /dev/null; then
    print_section "Checking for Firmware Updates"
    execute_cmd "fwupdmgr refresh"
    execute_cmd "fwupdmgr get-updates || echo 'No firmware updates available'"
    read -p "Apply firmware updates if available? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        execute_cmd "fwupdmgr update"
    fi
else
    echo -e "${YELLOW}fwupdmgr is not installed. Skipping firmware updates.${NC}"
    echo "To install: sudo apt install fwupd"
fi

# Update locate database
if command -v updatedb &> /dev/null; then
    print_section "Updating File Database"
    execute_cmd "updatedb"
fi

# Check disk space
print_section "Disk Space Status"
execute_cmd "df -h /"

# Check for broken packages
print_section "Checking for Broken Packages"
execute_cmd "dpkg --configure -a"
execute_cmd "apt --fix-broken install -y"

# Summary
print_section "System Update Summary"
echo "Update completed at: $(date)"
echo "Log file saved to: $LOG_FILE"

# Check if reboot is needed after updates
if [ -f /var/run/reboot-required ]; then
    echo -e "${YELLOW}A system reboot is required to complete the update process.${NC}"
    read -p "Would you like to reboot now? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "System will reboot now..."
        reboot
    else
        echo "Please remember to reboot your system later."
    fi
fi

print_section "System Update and Maintenance Completed"
