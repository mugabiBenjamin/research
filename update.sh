#!/bin/bash
# Enhanced Ubuntu System Update Script
# 
# This script performs a comprehensive system update and maintenance routine
# with robust error handling, memory management, security checks, and detailed logging.
#
# Instructions:
# 1. Save this file as "update.sh"
# 2. Make it executable: chmod +x update.sh
# 3. Run with sudo privileges: sudo ./update.sh

# Set error handling options
set -o pipefail
set -o errtrace  # Enable error tracing for functions

# Define colors for better output readability
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
BLUE="\033[0;34m"
CYAN="\033[0;36m"
NC="\033[0m" # No Color

# Function to display section headers
print_section() {
    echo -e "\n${YELLOW}$1${NC}"
    echo -e "${YELLOW}$(printf '=%.0s' {1..60})${NC}"
}

# Function to display progress within a section
print_progress() {
    echo -e "${CYAN}→ $1${NC}"
}

# Function to execute commands with robust error handling
# Parameters:
# $1: Command to execute
# $2: Allow failure (true/false, default: false)
# $3: Timeout in seconds (default: 300)
execute_cmd() {
    local cmd="$1"
    local allow_fail="${2:-false}"
    local timeout="${3:-300}"
    local max_retries=3
    local retry_count=0
    
    echo -e "${GREEN}> $cmd${NC}"
    
    # Try the command up to max_retries times
    while [ $retry_count -lt $max_retries ]; do
        # Execute the command with timeout and capture its output and return code
        output=$(timeout $timeout bash -c "$cmd" 2>&1)
        ret_val=$?
        
        # Check for timeout
        if [ $ret_val -eq 124 ]; then
            echo -e "${YELLOW}Command timed out after $timeout seconds.${NC}"
            retry_count=$((retry_count + 1))
            if [ $retry_count -lt $max_retries ]; then
                echo -e "${YELLOW}Retrying ($retry_count/$max_retries)...${NC}"
                continue
            else
                echo -e "${RED}Command timed out after $max_retries attempts.${NC}"
                break
            fi
        fi
        
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

# Function to check if package manager is in use
check_package_lock() {
    print_progress "Checking if package manager is currently in use..."
    
    # Check for apt/dpkg locks
    if lsof /var/lib/dpkg/lock-frontend &>/dev/null || lsof /var/lib/apt/lists/lock &>/dev/null || lsof /var/cache/apt/archives/lock &>/dev/null; then
        echo -e "${RED}Package manager is currently in use. Please wait or check for hanging processes.${NC}"
        echo "You might need to check the following processes:"
        ps aux | grep -E 'apt|dpkg' | grep -v grep
        return 1
    fi
    
    # Check for unattended-upgrades
    if pgrep unattended-upgrade &>/dev/null; then
        echo -e "${RED}Unattended-upgrades is currently running. Please wait for it to complete.${NC}"
        return 1
    fi
    
    echo -e "${GREEN}Package manager is available.${NC}"
    return 0
}

# Function to clear system caches
clear_system_caches() {
    print_section "Clearing System Caches"
    
    # Get memory stats before clearing
    print_progress "Current memory usage:"
    free -h
    
    # Clear PageCache, dentries and inodes
    print_progress "Clearing PageCache, dentries and inodes..."
    execute_cmd "sync" "false" "60"
    execute_cmd "echo 3 > /proc/sys/vm/drop_caches" "true" "30"
    
    # Clear swap if possible
    print_progress "Clearing swap..."
    if [ "$(free | grep -i swap | awk '{print $2}')" -ne 0 ]; then
        execute_cmd "swapoff -a && swapon -a" "true" "120"
    fi
    
    # Get memory stats after clearing
    print_progress "Memory usage after clearing caches:"
    free -h
}

# Function to clean temporary files
clean_temp_files() {
    print_section "Cleaning Temporary Files"
    
    # Clean /tmp directory (files older than 10 days)
    print_progress "Cleaning files in /tmp older than 10 days..."
    execute_cmd "find /tmp -type f -atime +10 -delete" "true" "120"
    
    # Clean user cache directories cautiously
    print_progress "Cleaning browser caches older than 30 days..."
    # Carefully clean only known cache directories that are safe to manipulate
    execute_cmd "find /home -path '*/mozilla/firefox/*/cache*' -type f -atime +30 -delete" "true" "180"
    execute_cmd "find /home -path '*/google-chrome/*/Cache/*' -type f -atime +30 -delete" "true" "180"
    
    # Clean apt cache from partial downloads
    print_progress "Cleaning package manager partial downloads..."
    execute_cmd "find /var/cache/apt/archives/partial/ -type f -delete" "true" "60"
}

# Function to rotate and clean old logs
clean_old_logs() {
    print_section "Log Rotation and Cleanup"
    
    # Get current disk usage of logs
    print_progress "Current log disk usage:"
    execute_cmd "du -sh /var/log/" "true" "30"
    
    # Force log rotation
    print_progress "Forcing log rotation..."
    execute_cmd "logrotate -f /etc/logrotate.conf" "true" "120"
    
    # Clean old rotated logs (older than 30 days)
    print_progress "Removing old rotated logs (older than 30 days)..."
    execute_cmd "find /var/log -name '*.gz' -o -name '*.old' -o -name '*.log.[0-9]' -mtime +30 -delete" "true" "180"
    
    # Clean journal logs if systemd is used
    if command -v journalctl &> /dev/null; then
        print_progress "Cleaning journal logs..."
        # Retain only past 7 days of logs and limit size
        execute_cmd "journalctl --vacuum-time=7d --vacuum-size=500M" "true" "120"
    fi
    
    # Get new disk usage of logs after cleanup
    print_progress "Log disk usage after cleanup:"
    execute_cmd "du -sh /var/log/" "true" "30"
}

# Function to perform security checks
perform_security_checks() {
    print_section "Security Checks"
    
    # Check for unattended-upgrades status
    print_progress "Checking unattended-upgrades status..."
    if dpkg -l | grep -q unattended-upgrades; then
        execute_cmd "systemctl status unattended-upgrades" "true" "30"
    else
        echo "unattended-upgrades package not installed"
    fi
    
    # Check for failed login attempts
    print_progress "Checking for failed login attempts..."
    execute_cmd "grep 'Failed password' /var/log/auth.log | tail -10" "true" "30"
    
    # Check for listening services
    print_progress "Listing public listening services (potential security concern)..."
    execute_cmd "ss -tulpn | grep -v '127.0.0.1' | grep -v '::1'" "true" "30"
    
    # Check recently modified system binaries (potential sign of compromise)
    print_progress "Checking for recently modified system binaries (last 24 hours)..."
    execute_cmd "find /bin /sbin /usr/bin /usr/sbin -mtime -1 -type f -exec ls -la {} \;" "true" "120"
}

# Function to get system baseline before updates
get_system_baseline() {
    print_section "System Baseline Before Updates"
    
    print_progress "Kernel version:"
    execute_cmd "uname -r" "true" "10"
    
    print_progress "Package statistics:"
    execute_cmd "dpkg --get-selections | grep -v deinstall | wc -l" "true" "30"
    
    print_progress "System uptime and load:"
    execute_cmd "uptime" "true" "10"
    
    print_progress "Memory usage:"
    execute_cmd "free -h" "true" "10"
    
    print_progress "Disk usage:"
    execute_cmd "df -h /" "true" "20"
    
    # Save important package versions for comparison
    print_progress "Saving important package versions..."
    BASELINE_FILE="/tmp/update-baseline-$(date +%Y%m%d-%H%M%S).log"
    dpkg-query -W -f='${Package} ${Version}\n' > $BASELINE_FILE
    echo "Baseline saved to $BASELINE_FILE"
}

# Function to compare system state after updates
compare_system_state() {
    print_section "System State Comparison After Updates"
    
    print_progress "Current kernel version:"
    execute_cmd "uname -r" "true" "10"
    
    print_progress "Current package statistics:"
    execute_cmd "dpkg --get-selections | grep -v deinstall | wc -l" "true" "30"
    
    print_progress "Current system uptime and load:"
    execute_cmd "uptime" "true" "10"
    
    print_progress "Current memory usage:"
    execute_cmd "free -h" "true" "10"
    
    print_progress "Current disk usage:"
    execute_cmd "df -h /" "true" "20"
    
    # Compare with baseline for important changes
    if [ -f "$BASELINE_FILE" ]; then
        print_progress "Packages that were updated:"
        CURRENT_STATE="/tmp/update-current-$(date +%Y%m%d-%H%M%S).log"
        dpkg-query -W -f='${Package} ${Version}\n' > $CURRENT_STATE
        print_progress "Comparing with baseline..."
        diff $BASELINE_FILE $CURRENT_STATE | grep -E '^[<>]' | grep -v '^< '
    else
        print_progress "Baseline file not found. Cannot compare."
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
echo "Logging output to $LOG_FILE"
exec > >(tee -i $LOG_FILE)
exec 2>&1

print_section "Starting System Update and Maintenance"
echo "Date: $(date)"
echo "Ubuntu Version: $(lsb_release -ds)"
echo "Kernel Version: $(uname -r)"
echo "Script Version: 2.0"

# Check for package manager locks before proceeding
if ! check_package_lock; then
    echo -e "${RED}Cannot proceed due to package manager locks.${NC}"
    echo "Try again later or resolve the lock issues manually."
    exit 1
fi

# Get system baseline before updates
get_system_baseline

# Check internet connectivity
print_section "Checking Internet Connectivity"
if ! ping -c 3 8.8.8.8 &>/dev/null; then
    echo -e "${YELLOW}Warning: Internet connectivity issues detected.${NC}"
    if ! ping -c 3 1.1.1.1 &>/dev/null; then
        echo -e "${RED}No internet connectivity confirmed. Cannot proceed with updates.${NC}"
        echo "Please check your network connection and try again."
        exit 1
    else
        echo "Limited connectivity detected. Proceeding with caution..."
    fi
else
    echo -e "${GREEN}Internet connectivity confirmed.${NC}"
fi

# Update the package lists securely
print_section "Updating Package Lists"
execute_cmd "apt update -y"

# Apply security updates first
print_section "Applying Security Updates"
execute_cmd "apt-get --only-upgrade install $(apt-get upgrade -s | grep -i security | awk '{print $2}' | tr '\n' ' ')" "true" "600"

# Fix any broken dependencies before proceeding
print_section "Fixing Package Dependencies"
execute_cmd "dpkg --configure -a" "true" "300"
execute_cmd "apt --fix-broken install -y" "true" "300"

# Upgrade packages without prompts
print_section "Upgrading All Packages"
execute_cmd "DEBIAN_FRONTEND=noninteractive apt upgrade -y -o Dpkg::Options::=\"--force-confdef\" -o Dpkg::Options::=\"--force-confold\"" "true" "900"

# Full upgrade (dist-upgrade) for package updates that require dependency changes
print_section "Performing Full Upgrade"
execute_cmd "DEBIAN_FRONTEND=noninteractive apt full-upgrade -y -o Dpkg::Options::=\"--force-confdef\" -o Dpkg::Options::=\"--force-confold\"" "true" "900"

# Clean up unused packages
print_section "Cleaning Up Unused Packages"
execute_cmd "apt autoremove --purge -y" "true" "300"
execute_cmd "apt autoclean -y" "true" "120"
execute_cmd "apt clean" "true" "120"

# Check if system uses snap
if command -v snap &> /dev/null; then
    print_section "Updating Snap Packages"
    execute_cmd "snap refresh" "true" "600"
    
    # Clean up old snap versions to free disk space
    print_progress "Cleaning old snap versions..."
    execute_cmd "snap list --all | awk '/disabled/{print $1, $3}' | while read snapname revision; do snap remove \"$snapname\" --revision=\"$revision\"; done" "true" "300"
fi

# Check if system uses flatpak
if command -v flatpak &> /dev/null; then
    print_section "Updating Flatpak Packages"
    execute_cmd "flatpak update -y" "true" "600"
    
    # Clean up unused flatpak runtimes and extensions
    print_progress "Cleaning flatpak unused runtimes..."
    execute_cmd "flatpak uninstall --unused -y" "true" "300"
fi

# Clean system caches
clear_system_caches

# Clean temporary files
clean_temp_files

# Rotate and clean logs
clean_old_logs

# Handle firmware updates with automatic response to prompts
if command -v fwupdmgr &> /dev/null; then
    print_section "Checking Firmware Status (Information Only)"
    print_progress "Refreshing firmware database..."
    execute_cmd "yes n | fwupdmgr refresh" "true" "120"
    
    print_progress "Checking for available firmware updates..."
    execute_cmd "yes n | fwupdmgr get-updates" "true" "120"
    
    echo "Note: Firmware updates should be reviewed and applied manually for system safety."
fi

# Update locate database
if command -v updatedb &> /dev/null; then
    print_section "Updating File Database"
    execute_cmd "updatedb" "true" "300"
fi

# Perform security checks
perform_security_checks

# Compare system state after updates
compare_system_state

# Check for kernel updates that require reboot
print_section "Kernel Update Check"
CURRENT_KERNEL=$(uname -r)
LATEST_KERNEL=$(dpkg -l | grep 'linux-image-[0-9]' | sort -V | tail -n 1 | awk '{print $2}' | sed 's/linux-image-//')
if [ "$CURRENT_KERNEL" != "$LATEST_KERNEL" ] && [ ! -z "$LATEST_KERNEL" ]; then
    echo -e "${YELLOW}Kernel update detected!${NC}"
    echo -e "Current kernel: ${CYAN}$CURRENT_KERNEL${NC}"
    echo -e "Latest installed: ${CYAN}$LATEST_KERNEL${NC}"
    echo -e "${YELLOW}A reboot is required to use the new kernel.${NC}"
fi

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

# List services that may need to be restarted
print_section "Services That May Need Restart"
if command -v needrestart &> /dev/null; then
    execute_cmd "needrestart -b" "true" "60"
else
    echo "needrestart tool not installed. Consider installing it for better service restart management."
    echo "You can install it with: sudo apt install needrestart"
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
echo "   - Update the signing key with: curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null"

# Final note about the integrity of the system
print_section "System Integrity Note"
echo "The system update process has completed. This script has been designed to:"
echo "1. Apply updates in a safe order (security updates first)"
echo "2. Clean up unnecessary files to free disk space"
echo "3. Provide detailed information about the system state"
echo "4. Identify potential issues that may require attention"
echo
echo "To ensure continued system stability, consider:"
echo "1. Review the log file at $LOG_FILE for any errors"
echo "2. Perform a reboot if indicated by the system or kernel update"
echo "3. Run this script periodically (e.g., weekly) for system maintenance"

# End of the script

# In this bash script, just recommend changes, improvements, enhancements and modifications that can be implemented, having in consideration graceful handling of potential errors, clearing redundant memory (cache, dentries, inodes and temporary files), log rotation by deleting old logs, security enhancements like Checking for and applying security updates, functionality improvements, conflict prevention. Add comments to explain what each part of the script does, Idempotency: Ensure that running the script multiple times produces the same result (where applicable). For example, running the update command twice shouldn't cause issues. And in the long run, the script should not  compromise the system. Also the script should not abstract any steps and process. It should show every step it is currently on running in the terminal with its respective progress