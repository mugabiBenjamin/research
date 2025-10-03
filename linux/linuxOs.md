# Linux

## Introduction to Linux Families

### The Red Hat Family (RHEL -> Red Hat Enterprise Linux)

- CentOs, centOs stream
- Fedora, contains more softare
- oracle linux
- uses `yum` package manger

### The SUSE Family

- openSUSE
- SLES
- uses `RPM-based zypper` package manager

### The Debian Family

- Ubuntu
- Debian family is upstream for Ubuntu
- uses `dpkg-based apt` package manager

- **Kernel:** is the brain of the linux OS. It controls the hardware e.g `Linux kernel`
- **Distro:** is a collection of software combined with the linus kernel
- **Bootloader:** is a program that boots the OS e.g `GRUB` ans `ISOLINUX`
- **Serice:** is a program that runs background process e.g `httpd`, `nfsd`, `ntpd`, `ftpd`, etc
- **File System:** is a method for storing and organising files in linux e.g `ext3`, `ext4`, `FAT`, `XFS`, `NFTS`, `Btrfs`, etc
- **X Window System:** provides the standard tool kit and protocol to build GUIs on nearly all linux systems
- **Desktop Environment (DE):** is a GUI on top of the OS
  e.g `GNOME`, `KDE`, `Xfce`, `LXDE`, `Fluxbox`, etc
- **Command Line:** is an interface for typing commands on top of the OS
- **Shell:** is the CLI interpreter that interpretes the CLI input and instructions the OS to perform actions e.g `Bash`, `tcsh`, `zsh`, etc
- **Partition** is a container in which a file system resides

## The Command Line

Most input commands entered in the command line are separated by spaces. They have 3 basic elements

`<command>` `<-options>` `<arguements>` </br>
E.g. `ls` `-a` `/home/user`

## Rebooting and shutting down a Linux system

```bash
# Shut down the system
shutdown -h now

# Reboot the system
shutdown -r now

# Reboot the system at a specific time
sudo shutdown -r 10:00 "Shutting down for scheduled maintenance"

# Reboot the system at a specific date
shutdown -r "2023-06-01"

# Reboot the system at a specific date and time
shutdown -r "2023-06-01 10:00"

# Cancel a scheduled reboot
shutdown -c
```

## Locating applications

Executable programs and scripts live in the:

```bash
`/bin` || `/usr/bin` || `/sbin` || `/usr/sbin` || `/opt` || `/usr/local/bin` || `/usr/local/sbin` || `/home/user/bin`
# directories
```

To locate programs, use the `which` command. If `which` fails, use the `whereis` command

## Getting Help

### man - Manual Pages

```bash
# Display manual for a command
man ls
man grep

# Search manual pages by keyword
man -k network
apropos network
```

### whatis - Brief Command Description

```bash
# Display brief information about a command
whatis ls
whatis grep
whatis chmod
```

### help - Built-in Help

```bash
# Get help for built-in commands
help cd
help echo

# Command help options
ls --help
grep --help
```

## Directory Operations

### pwd - Print Working Directory

```bash
# Show current directory path
pwd
```

### cd - Change Directory

```bash
# Go to home directory
cd
cd ~

# Go to specific directory
cd /path/to/directory

# Go to parent directory
cd ..

# Go back to previous directory
cd -

# Go to root directory
cd /
```

### ls - List Directory Contents

```bash
# Basic listing
ls

# List all files (including hidden)
ls -a

# Long format with details
ls -l

# Human-readable file sizes
ls -lh

# Combine options
ls -lah

# List specific directory
ls /path/to/directory

# Sort by modification time
ls -lt

# Reverse sort order
ls -lr
```

### mkdir - Create Directories

```bash
# Create single directory
mkdir directory_name

# Create multiple directories
mkdir dir1 dir2 dir3

# Create nested directories
mkdir -p path/to/nested/directory

# Create with specific permissions
mkdir -m 755 directory_name
```

### rmdir - Remove Empty Directories

```bash
# Remove empty directory
rmdir directory_name

# Remove nested empty directories
rmdir -p path/to/nested/directory
```

### rm - Remove Files and Directories

```bash
# Remove file
rm filename

# Remove multiple files
rm file1 file2 file3

# Remove with confirmation
rm -i filename

# Remove directory and contents (recursive)
rm -r directory_name

# Force remove without confirmation
rm -rf directory_name

# Remove files matching pattern
rm *.txt
```

## File Operations

### file - Identify File Type

```bash
# Check file type
file filename
file image.png
file /bin/ls

# Check multiple files
file *
```

### touch - Create Files and Update Timestamps

```bash
# Create empty file
touch filename

# Create multiple files
touch file1.txt file2.txt file3.txt

# Create numbered files
touch file{1..10}.txt

# Update file timestamp
touch existing_file

# Set specific timestamp
touch -d "2024-01-01" filename
touch -d tomorrow filename
```

### cp - Copy Files and Directories

```bash
# Copy file
cp source destination

# Copy file to directory
cp file.txt /path/to/directory/

# Copy multiple files to directory
cp file1.txt file2.txt /destination/

# Copy directory recursively
cp -r source_directory destination_directory

# Copy with confirmation
cp -i source destination

# Preserve file attributes
cp -p source destination

# Copy and create backup
cp --backup source destination
```

### mv - Move/Rename Files and Directories

```bash
# Rename file
mv old_name new_name

# Move file to directory
mv file.txt /path/to/directory/

# Move multiple files
mv file1.txt file2.txt /destination/

# Rename directory
mv old_directory new_directory

# Move with confirmation
mv -i source destination
```

### ln - Create Links

```bash
# Create hard link
ln target_file link_name

# Create symbolic link
ln -s target_file symlink_name
ln -s /path/to/target /path/to/symlink

# Create symbolic link to directory
ln -s /path/to/directory /path/to/symlink

# Overwrite existing symlink
ln -sf new_target existing_symlink

# Create multiple hard links
ln target_file link1 link2 link3
```

### shred - Securely Delete Files

```bash
# Overwrite file data
shred filename

# Overwrite and remove file
shred -u filename

# Multiple overwrite passes
shred -n 3 filename

# Overwrite multiple files
shred file1.txt file2.txt

# Verbose output
shred -v filename
```

## File Content Viewing

### cat - Display File Contents

```bash
# Display file content
cat filename

# Display multiple files
cat file1.txt file2.txt

# Number lines
cat -n filename

# Show non-printing characters
cat -v filename

# Concatenate files and redirect
cat file1.txt file2.txt > combined.txt
```

### head - Display Beginning of Files

```bash
# Show first 10 lines (default)
head filename

# Show first N lines
head -n 5 filename
head -5 filename

# Show multiple files
head file1.txt file2.txt

# Show first N bytes
head -c 100 filename
```

### tail - Display End of Files

```bash
# Show last 10 lines (default)
tail filename

# Show last N lines
tail -n 5 filename
tail -5 filename

# Follow file changes (useful for logs)
tail -f logfile

# Show multiple files
tail file1.txt file2.txt

# Show last N bytes
tail -c 100 filename
```

### more - Page Through Files

```bash
# View file page by page
more filename

# Navigate: Space (next page), q (quit), h (help)
```

### less - Advanced File Pager

```bash
# View file with navigation
less filename

# Navigate: Space (next page), b (previous page), q (quit)
# Search: /pattern (forward), ?pattern (backward)
# Go to line: :n (line number n)
```

### echo - Display Text

```bash
# Display text
echo "Hello World"

# Write to file (overwrite)
echo "Hello World" > filename

# Append to file
echo "Hello World" >> filename

# Display variables
echo $HOME
echo $PATH

# Disable newline
echo -n "No newline"
```

## File Permissions and Ownership

### chmod - Change File Permissions

```bash
# Using octal notation
chmod 755 filename      # rwxr-xr-x
chmod 644 filename      # rw-r--r--
chmod 600 filename      # rw-------

# Using symbolic notation
chmod +x filename       # Add execute permission
chmod -x filename       # Remove execute permission
chmod u+x filename      # Add execute for user
chmod g+r filename      # Add read for group
chmod o-w filename      # Remove write for others

# Recursive permission change
chmod -R 755 directory/

# Make script executable
chmod +x script.sh
./script.sh
```

### chown - Change File Ownership

```bash
# Change owner
chown username filename

# Change owner and group
chown username:groupname filename

# Change group only
chown :groupname filename

# Recursive ownership change
chown -R username:groupname directory/

# Using numeric IDs
chown 1000:1000 filename
```

### chgrp - Change Group Ownership

```bash
# Change group
chgrp groupname filename

# Recursive group change
chgrp -R groupname directory/
```

### umask - Set Default Permissions

```bash
# Display current umask
umask

# Set umask (permissions to subtract)
umask 022

# Set umask symbolically
umask u=rwx,g=rx,o=rx
```

## Searching and Text Processing

### grep - Search Text Patterns

```bash
# Basic search
grep "pattern" filename

# Case-insensitive search
grep -i "pattern" filename

# Recursive search in directories
grep -r "pattern" directory/

# Search with line numbers
grep -n "pattern" filename

# Search for whole words only
grep -w "word" filename

# Invert match (lines not containing pattern)
grep -v "pattern" filename

# Count matches
grep -c "pattern" filename

# Search multiple files
grep "pattern" file1.txt file2.txt

# Search using regular expressions
grep -E "pattern1|pattern2" filename
```

### find - Search Files and Directories

```bash
# Find by name
find /path -name "filename"
find . -name "*.txt"

# Case-insensitive name search
find . -iname "*.TXT"

# Find by type
find . -type f        # Files only
find . -type d        # Directories only

# Find by size
find . -size +100M    # Larger than 100MB
find . -size -1k      # Smaller than 1KB

# Find by modification time
find . -mtime -7      # Modified in last 7 days
find . -mtime +30     # Modified more than 30 days ago

# Find and execute command
find . -name "*.tmp" -delete
find . -name "*.txt" -exec cp {} /backup/ \;

# Find by permissions
find . -perm 644
```

### which - Locate Command

```bash
# Find command location
which ls
which python
which gcc
```

### locate - Find Files by Name

```bash
# Find files (requires updatedb)
locate filename
locate "*.conf"

# Update locate database
sudo updatedb
```

### awk - Text Processing

```bash
# Print specific columns
awk '{print $1}' filename
awk '{print $1, $3}' filename

# Print lines matching pattern
awk '/pattern/ {print}' filename

# Print with conditions
awk '$3 > 100 {print}' filename

# Field separator
awk -F: '{print $1}' /etc/passwd
```

### sed - Stream Editor

```bash
# Substitute text
sed 's/old/new/' filename
sed 's/old/new/g' filename    # Global replacement

# Delete lines
sed '2d' filename             # Delete line 2
sed '/pattern/d' filename     # Delete lines matching pattern

# Print specific lines
sed -n '1,5p' filename        # Print lines 1-5
```

### sort - Sort File Contents

```bash
# Sort alphabetically
sort filename

# Sort numerically
sort -n filename

# Reverse sort
sort -r filename

# Sort by specific column
sort -k2 filename

# Remove duplicates while sorting
sort -u filename

# Sort and save to file
sort filename -o sorted_file.txt

# Sort from pipe
cat filename | sort
```

### uniq - Report or Filter Unique Lines

```bash
# Remove duplicate lines (requires sorted input)
uniq filename

# Count occurrences
uniq -c filename

# Show only duplicates
uniq -d filename

# Show only unique lines
uniq -u filename
```

### wc - Word, Line, Character Count

```bash
# Count lines, words, characters
wc filename

# Count lines only
wc -l filename

# Count words only
wc -w filename

# Count characters only
wc -c filename
```

## Archiving and Compression

### tar - Archive Files

```bash
# Create archive
tar -cvf archive.tar directory/
tar -cvf archive.tar file1 file2 file3

# Create compressed archive
tar -czvf archive.tar.gz directory/     # gzip
tar -cjvf archive.tar.bz2 directory/    # bzip2

# Extract archive
tar -xvf archive.tar
tar -xzvf archive.tar.gz

# List archive contents
tar -tvf archive.tar

# Extract specific files
tar -xvf archive.tar filename

# Extract to specific directory
tar -xvf archive.tar -C /destination/
```

### zip - Create ZIP Archives

```bash
# Create zip archive
zip archive.zip file1.txt file2.txt

# Create zip from directory
zip -r archive.zip directory/

# Create zip with compression level
zip -9 archive.zip file.txt    # Maximum compression

# Add to existing archive
zip archive.zip newfile.txt
```

### unzip - Extract ZIP Archives

```bash
# Extract zip archive
unzip archive.zip

# Extract to specific directory
unzip archive.zip -d /destination/

# List archive contents
unzip -l archive.zip

# Extract specific files
unzip archive.zip filename
```

### gzip/gunzip - Compress/Decompress Files

```bash
# Compress file
gzip filename          # Creates filename.gz

# Decompress file
gunzip filename.gz

# Keep original file
gzip -k filename

# Compress with maximum compression
gzip -9 filename
```

## Network and Downloads

### wget - Download Files

```bash
# Download file
wget https://example.com/file.txt

# Download and save with specific name
wget https://example.com/file.txt -O newname.txt

# Download to specific directory
wget https://example.com/file.txt -P /path/to/directory/

# Continue partial download
wget -c https://example.com/largefile.zip

# Download multiple files from a list
wget -i list.txt
# first_url
# second_url

# Mirrors a website, recursively downloading all pages, images, and files
wget -m https://example.com/

# Creates a complete, offline-browsable copy of the website
wget --mirror --page-requisites --convert-link --no-clobber --no-parent --domains example.com https://example.com/

# short hand version:
wget -mpkNnp -D example.com --no-clobber https://example.com/
# -m = --mirror
# -p = --page-requisites
# -E = --adjust-extension (not --convert-links, but related)
# -k = --convert-links
# -N = --timestamping (already in -m)
# -np = --no-parent
# -D = --domains
# There's no short flag for --no-clobber

# ==========================================

# -r (recursive) downloads pages and follows links indefinitely.
# -m (mirror) is -r plus:
   # -N (timestamping - only downloads newer files)
   # -l inf (infinite depth)
   # --no-remove-listing (keeps FTP listings)
# So -m is designed for creating/updating website mirrors, while -r is just basic recursion.

wget -r -p -c -k -K -e robots=off https://example.com
# -r = recursive download
# -p = page requisites (CSS, images, JS)
# -c = continue partially downloaded files
# -k = convert links for offline browsing
# -K = backup original files before conversion
# -e robots=off = ignore robots.txt (aggresive scrapping, downloads restricted areas, Violate site's terms of service, Could get your IP blocked)

# Download recursively
wget -r https://example.com/directory/

# Limit download speed
wget --limit-rate=200k https://example.com/file.txt
wget --limit-rate=2M https://example.com/file.txt

# Download large file in background even terminal is closed
nohup wget https://example.com/file.zip &
# or
nohup wget -b https://example.com/file.zip

wget -r ftp://test.rebex.net --user=demo --password=password
```

### curl - Transfer Data

```bash
# Download file
curl https://example.com/file.txt

# Save to file
curl https://example.com/file.txt -o filename.txt

# Follow redirects
curl -L https://example.com/redirect

# Send POST request
curl -X POST -d "data=value" https://example.com/api

# Include headers
curl -H "Content-Type: application/json" https://example.com/api

# Download with progress bar
curl -# https://example.com/file.txt -o file.txt
```

### ping - Test Network Connectivity

```bash
# Ping host
ping google.com

# Ping with count
ping -c 4 google.com

# Ping with interval
ping -i 2 google.com
```

### ssh - Secure Shell

```bash
# Connect to remote host
ssh user@hostname

# Connect with specific port
ssh -p 2222 user@hostname

# Execute command remotely
ssh user@hostname 'ls -la'

# Copy SSH key
ssh-copy-id user@hostname
```

### scp - Secure Copy

```bash
# Copy file to remote host
scp file.txt user@hostname:/remote/path/

# Copy file from remote host
scp user@hostname:/remote/file.txt ./

# Copy directory recursively
scp -r directory/ user@hostname:/remote/path/

# Copy with specific port
scp -P 2222 file.txt user@hostname:/remote/path/
```

### rsync - Synchronize Files

```bash
# Basic sync
rsync -av source/ destination/

# Sync to remote host
rsync -av directory/ user@hostname:/remote/path/

# Sync with progress
rsync -av --progress source/ destination/

# Exclude files
rsync -av --exclude='*.tmp' source/ destination/

# Delete files not in source
rsync -av --delete source/ destination/
```

## Process Management

### ps - Display Processes

```bash
# Show processes for current user
ps

# Show all processes
ps aux

# Show process tree
ps auxf

# Show processes for specific user
ps -u username

# Show specific process
ps -p PID
```

### top - Display Running Processes

```bash
# Show top processes (interactive)
top

# Sort by CPU usage: P
# Sort by memory usage: M
# Kill process: k
# Quit: q
```

### htop - Enhanced Process Viewer

```bash
# Interactive process viewer (if installed)
htop

# More user-friendly than top
# F9: Kill process, F6: Sort options
```

### kill - Terminate Processes

```bash
# Kill process by PID
kill PID

# Force kill process
kill -9 PID

# Kill by process name
killall process_name

# Kill all processes of a user
killall -u username

# List available signals
kill -l
```

### jobs - Display Active Jobs

```bash
# Show current jobs
jobs

# Show job PIDs
jobs -l

# Bring job to foreground
fg %1

# Send job to background
bg %1
```

### nohup - Run Commands Immune to Hangups

```bash
# Run command in background
nohup command &

# Run with output redirection
nohup command > output.log 2>&1 &
```

## System Information

### uname - System Information

```bash
# Show system information
uname -a

# Show kernel name
uname -s

# Show kernel version
uname -r

# Show machine architecture
uname -m
```

### uptime - System Uptime

```bash
# Show system uptime and load
uptime

# Show uptime in pretty format
uptime -p
```

### whoami - Current User

```bash
# Show current username
whoami

# Show current user ID
id

# Show all user information
id -a
```

### who - Logged in Users

```bash
# Show logged in users
who

# Show detailed information
who -a

# Show current terminal
tty
```

### df - Disk Space Usage

```bash
# Show disk usage
df

# Human-readable format
df -h

# Show filesystem types
df -T

# Show specific filesystem
df /home
```

### du - Directory Size

```bash
# Show directory size
du directory/

# Human-readable format
du -h directory/

# Summary only
du -s directory/

# Show all subdirectories
du -a directory/

# Sort by size
du -h directory/ | sort -h
```

### free - Memory Usage

```bash
# Show memory usage
free

# Human-readable format
free -h

# Show in MB
free -m

# Show continuously
free -h -s 2
```

### lscpu - CPU Information

```bash
# Show CPU information
lscpu

# Show CPU architecture
arch
```

### lsblk - Block Devices

```bash
# List block devices
lsblk

# Show filesystem information
lsblk -f
```

### mount - Mount Filesystems

```bash
# Show mounted filesystems
mount

# Mount filesystem
mount /dev/sdb1 /mnt/usb

# Unmount filesystem
umount /mnt/usb
```

## Text Editors

### nano - Simple Text Editor

```bash
# Edit file
nano filename

# Key commands:
# Ctrl+O: Save
# Ctrl+X: Exit
# Ctrl+W: Search
# Ctrl+G: Help
```

### vim - Advanced Text Editor

```bash
# Edit file
vim filename

# Basic vim commands:
# i: Insert mode
# Esc: Command mode
# :w: Save
# :q: Quit
# :wq: Save and quit
# :q!: Quit without saving
```

### emacs - Another Advanced Editor

```bash
# Edit file
emacs filename

# Basic emacs commands:
# Ctrl+X Ctrl+S: Save
# Ctrl+X Ctrl+C: Exit
# Ctrl+X Ctrl+F: Open file
```

## Environment Variables

### env - Environment Variables

```bash
# Show all environment variables
env

# Show specific variable
echo $HOME
echo $PATH
echo $USER

# Set temporary variable
export VAR_NAME="value"

# Add to PATH
export PATH=$PATH:/new/path
```

### history - Command History

```bash
# Show command history
history

# Execute previous command
!!

# Execute command by number
!123

# Search history
Ctrl+R

# Clear history
history -c
```

### alias - Command Aliases

```bash
# Show current aliases
alias

# Create alias
alias ll='ls -la'
alias grep='grep --color=auto'

# Remove alias
unalias ll
```

## File Comparison

### cmp - Compare Files Byte by Byte

```bash
# Compare two files
cmp file1.txt file2.txt

# Verbose output
cmp -v file1.txt file2.txt

# Silent mode (exit code only)
cmp -s file1.txt file2.txt
```

### diff - Compare Files Line by Line

```bash
# Compare two files
diff file1.txt file2.txt

# Unified format
diff -u file1.txt file2.txt

# Context format
diff -c file1.txt file2.txt

# Compare directories
diff -r dir1/ dir2/

# Ignore case differences
diff -i file1.txt file2.txt
```

## Administrative Commands

### sudo - Execute as Another User

```bash
# Run command as root
sudo command

# Switch to root shell
sudo -i
sudo su -

# Run command as specific user
sudo -u username command

# Edit sudoers file
sudo visudo
```

### su - Switch User

```bash
# Switch to root
su -

# Switch to specific user
su username

# Execute single command
su -c "command"
```

### passwd - Change Password

```bash
# Change own password
passwd

# Change another user's password (as root)
passwd username
```

## Formatting and disk partitioning

1. **Identify the USB Drive:**

   - Open the terminal (`Ctrl + Alt + T`).
   - Run `lsblk` to list all block devices.
   - Identify your USB drive (e.g., `/dev/sdb`).

2. **Open `fdisk`:**

   - Run `sudo fdisk /dev/sdX` (replace `/dev/sdX` with your USB drive's identifier).

3. **Create a New Partition Table (if necessary):**

   - Type `m` for help
   - Type `g` for GPT partition table

4. **Create a New Partition:**

   - Type `n` to create a new partition.
   - After the `g` command, you correctly typed `n` to create a new partition.
   - Now, you need to follow the prompts to define the partition.
   - `Partition number (1-128, default 1):` Press Enter to accept the default (1).
   - `First sector (2048-..., default 2048):` Press Enter to accept the default.
   - `Last sector, +sectors or +size{K,M,G,T,P} (2048-..., default ...):`
     - To use the entire remaining space, press Enter.
     - Do you want to remove the signature? `[Y]es/[N]o:` Type `y`
     - **_To specify a size, you can use `+size` (e.g., `+2G` for a 2GB partition)._**

5. **Write the Changes:**

   - After defining the partition, type `w` to write the changes to the disk.

### Example

```bash
sudo fdisk /dev/sdb # replace sdb with your usb device.
# inside fdisk:
g # create GPT partition table
n # create new partition
# press enter (partition number 1)
# press enter (first sector default)
# press enter (last sector default, using all space)
y # remove signature
w # write changes and exit
```

### Formatting commands

- **FAT32:** `sudo mkfs.vfat /dev/sdX1` (replace `/dev/sdX1` with your partition's identifier).

- **NTFS:** `sudo mkfs.ntfs /dev/sdX1` (you might need to install the `ntfs-3g` package: `sudo apt install ntfs-3g`).

```bash
sudo mkfs.vfat /dev/sdb1
```

### Unmounting a Partition in "Disks"

1. **Open the Disks Application:**

   - Search for "Disks" in your applications menu and open it.

2. **Select the USB Drive:**

   - In the left-hand panel, click on the USB drive you want to work with.

3. **Identify the Partition:**

   - In the main panel, you'll see a visual representation of the drive and its partitions. Click on the specific partition you want to unmount.

4. **Unmount the Partition:**

   - Look for a `small square "stop" icon` (it might look like a stop button). This icon will only appear if the partition is currently mounted.
   - Click the "stop" icon. This will unmount the partition.
   - Alternatively, sometimes a menu will appear with a unmount option, depending on the version of ubuntu.

- **_Always unmount the partition before changing its label or renaming it._**

### Renaming a USB drive

- Open the `"Disks" application`.
- Select your USB drive from the list on the left.
- If the partition is mounted, unmount it.
- Click the `gear icon` (usually `"Additional partition options"`) and select `"Edit Filesystem."`
- In the `"Label" field`, enter your desired name and click `Change`.

[Back to top](#linux)
