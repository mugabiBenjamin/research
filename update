#!/bin/bash  
# create file and name it "update.old.sh"  
# run "chmod +x update.old.sh" to make file executable  
# run "sudo ./update.old.sh"  

# Update and upgrade the package lists and installed packages  
apt update -y          # Update the list of available packages  
apt upgrade -y         # Upgrade all installed packages to their latest versions  
apt full-upgrade -y    # Perform a complete upgrade, handling dependencies and removals  

# Clean up unused and outdated packages  
apt autoremove --purge -y  # Remove unnecessary packages and their configuration files  
apt autoclean -y           # Clean up outdated package cache  

# Update Snap and Flatpak packages  
snap refresh              # Update all installed Snap packages  
flatpak update -y         # Update all installed Flatpak packages (if Flatpak is used)  

# Update firmware  
# fwupdmgr update           # Check for and apply firmware updates  

# Finished  
echo "-------------------------------------------"  
echo "> System update and maintenance completed!"  
echo "-------------------------------------------"  
