#!/bin/bash
# create file and name it "update.sh"
# run "chmod +x update.sh" to make file executable
# run "sudo ./update.sh"


# Update and upgrade the package lists and installed packages
sudo apt update -y              # Update the list of available packages
sudo apt upgrade -y             # Upgrade all installed packages to their latest versions
sudo apt full-upgrade -y        # Perform a complete upgrade, handling dependencies and removals

# Clean up unused and outdated packages
sudo apt autoremove --purge -y  # Remove unnecessary packages and their configuration files
sudo apt autoclean -y           # Clean up outdated package cache

# Update Snap and Flatpak packages
sudo snap refresh               # Update all installed Snap packages
sudo flatpak update -y          # Update all installed Flatpak packages (if Flatpak is used)

# Update firmware
# sudo fwupdmgr update          # Check for and apply firmware updates

# Finished
echo "-------------------------------------------"
echo "> System update and maintenance completed!"
echo "-------------------------------------------"
