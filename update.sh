#!/bin/bash
# Robust Ubuntu System Update Script
# 
# Instructions:
# 1. Save this file as "update.sh"
# 2. Make it executable: chmod +x update.sh
# 3. Run with sudo privileges: sudo ./update.sh

# Set error handling options
set -o pipefail

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

# Function to execute commands with robust error handling
execute_cmd() {
    local cmd="$1"
    local allow_fail="${2:-false}"
    local max_retries=3
    local retry_count=0
    
    echo -e "${GREEN}> $cmd${NC}"
    
    # Try the command up to max_retries times
    while [ $retry_count -lt $max_retries ]; do
        # Execute the command and capture its output and return code
        output=$(eval "$cmd" 2>&1)
        ret_val=$?
        
        # Print the output regardless of success or failure
        echo "$output"
        
        # If command succeeded, return success
        if [ $ret_val -eq 0 ]; then
            return 0
        fi
        
        # Command failed, increment retry counter
        retry_count=$((retry_count + 1))
        
        # If we haven't reached max retries, wait and try again
        if [ $retry_count -lt $max_retries ]; then
            echo -e "${YELLOW}Command failed, retrying ($retry_count/$max_retries)...${NC}"
            sleep 5
        fi
    done
    
    # If we've exhausted retries or allow_fail is true, we can continue
    if [ "$allow_fail" = "true" ]; then
        echo -e "${YELLOW}Command failed after $retry_count attempts, but continuing as failure is allowed.${NC}"
        return 0
    else
        echo -e "${RED}Command failed after $retry_count attempts.${NC}"
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

# Check internet connectivity
print_section "Checking Internet Connectivity"
if ! ping -c 1 8.8.8.8 &>/dev/null; then
    echo -e "${YELLOW}Warning: Internet connectivity issues detected.${NC}"
    echo "Updates will be attempted but may fail."
else
    echo "Internet connectivity confirmed."
fi

# Update the main Ubuntu repositories first, with retry and allow failure
print_section "Updating Core Package Lists"
execute_cmd "apt update -y -o Acquire::AllowInsecureRepositories=true -o Acquire::AllowDowngradeToInsecureRepositories=true -o APT::Get::AllowUnauthenticated=true --allow-unauthenticated" "true"

# Upgrade packages without prompts, allow failure
print_section "Upgrading Installed Packages"
execute_cmd "DEBIAN_FRONTEND=noninteractive apt upgrade -y -o Dpkg::Options::=\"--force-confdef\" -o Dpkg::Options::=\"--force-confold\" --allow-unauthenticated" "true"
execute_cmd "DEBIAN_FRONTEND=noninteractive apt full-upgrade -y -o Dpkg::Options::=\"--force-confdef\" -o Dpkg::Options::=\"--force-confold\" --allow-unauthenticated" "true"

# Clean up unused packages
print_section "Cleaning Up Unused Packages"
execute_cmd "apt autoremove --purge -y" "true"
execute_cmd "apt autoclean -y" "true"

# Check if system uses snap
if command -v snap &> /dev/null; then
    print_section "Updating Snap Packages"
    execute_cmd "snap refresh" "true"
fi

# Check if system uses flatpak
if command -v flatpak &> /dev/null; then
    print_section "Updating Flatpak Packages"
    execute_cmd "flatpak update -y" "true"
fi

# Handle firmware updates with automatic response to prompts
if command -v fwupdmgr &> /dev/null; then
    print_section "Checking Firmware Status (Information Only)"
    yes n | fwupdmgr refresh 2>/dev/null || echo "Firmware refresh skipped due to error"
    yes n | fwupdmgr get-updates 2>/dev/null || echo "No firmware updates available or error checking updates"
    
    echo "Note: Firmware updates should be reviewed and applied manually for system safety."
fi

# Update locate database
if command -v updatedb &> /dev/null; then
    print_section "Updating File Database"
    execute_cmd "updatedb" "true"
fi

# Check disk space
print_section "Disk Space Status"
execute_cmd "df -h /" "true"

# Check for broken packages
print_section "Checking for Broken Packages"
execute_cmd "dpkg --configure -a" "true"
execute_cmd "apt --fix-broken install -y" "true"

# Fix possible issues with package management system
print_section "Fixing Package Management Issues"
execute_cmd "apt clean" "true"

# Summary
print_section "System Update Summary"
echo "Update completed at: $(date)"
echo "Log file saved to: $LOG_FILE"

# List repositories with errors
print_section "Repositories with Errors"
grep -B1 "Failed to fetch" $LOG_FILE | grep -v -- "--" || echo "No repository errors found."

# Check if reboot is needed after updates
if [ -f /var/run/reboot-required ]; then
    echo -e "${YELLOW}A system reboot is required to complete the update process.${NC}"
    echo "Please reboot your system when convenient using: sudo reboot"
fi

print_section "System Update and Maintenance Completed"

# Provide suggestions for fixing repository issues
print_section "Suggestions for Repository Issues"
echo "If you encountered repository errors, consider these manual fixes:"
echo "1. For certificate verification failures:"
echo "   - sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys [KEY]"
echo "   - Or remove problematic repositories in /etc/apt/sources.list.d/"
echo "2. For mirror sync issues:"
echo "   - Try again later when mirrors have completed synchronization"
echo "   - Or switch to main Ubuntu mirrors temporarily"
echo "3. For ongoing Microsoft repository issues:"
echo "   - sudo rm /etc/apt/sources.list.d/vscode.list (if VS Code is already installed)"
echo "   - Or update the signing key with: curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -"