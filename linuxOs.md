# Linux

- [Working with Directories](#working-with-directories)
  - [man command](#man-command)
  - [pwd command](#pwd-command)
  - [cd command](#cd-command)
  - [ls command](#ls-command)
  - [mkdir command](#mkdir-command)
  - [rmdir command](#rmdir-command)
  - [rm command with directories](#rm-command-with-directories)
- [Working with Files](#working-with-files)
  - [file command](#file-command)
  - [touch command](#touch-command)
  - [rm command with files](#rm-command-with-files)
  - [cp command](#cp-command)
  - [mv command](#mv-command)
- [Viewing File Contents](#viewing-file-contents)
  - [head command](#head-command)
  - [tail command](#tail-command)
  - [cat command](#cat-command)
  - [echo command](#echo-command)
  - [more command](#more-command)
  - [less command](#less-command)
- [Linux File System Structure](#linux-file-system-structure)
- [System Information](#system-information)
- [Miscelleneous commands](#miscelleneous-commands)
  - [File Permissions and Ownership](#file-permissions-and-ownership)
  - [Searching and Locating Files](#searching-and-locating-files)
  - [Archiving and Downloading Files](#archiving-and-downloading-files)
  - [Remote Access and Process Management](#remote-access-and-process-management)
  - [Administrative Privileges and Disk Usage](#administrative-privileges-and-disk-usage)
- [Formatting and disk partitioning](#formatting-and-disk-partitioning)
  - [Formatting commands](#formatting-commands)
  - [Unmounting a Partition in "Disks"](#unmounting-a-partition-in-disks)
  - [Renaming a USB drive](#renaming-a-usb-drive)

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

## Working with Directories

### man command

```bash
# Shows help documentation for a specified command.
man – Displays the manual for a command.

# Displays the manual for the 'ls' command.
- Example: `man ls`
```

### pwd command

```bash
# Outputs the path of the current directory.
pwd – Prints the current working directory.
```

### cd command

```bash
# Changes the current directory to a specified path.
cd – Changes directory.

# Navigates to the user's home directory.
- `cd` (without arguments) returns to the home directory.

# Switches back to the previous directory.
- `cd -` toggles between the last two directories.

# Can use full paths or paths relative to the current directory.
- Supports absolute and relative paths.
```

### ls command

```bash
# Displays files and directories within the current directory.
ls – Lists directory contents.

# Lists all files, including those starting with a dot.
- `ls -a` – Show all files, including hidden ones.

# Provides detailed information about each file.
- `ls -l` – Long listing format.

# Displays file sizes in a human-readable format.
- `ls -h` – Human-readable sizes.

# Shows all files with detailed information and readable sizes.
- `ls -lah` – Combines all options above.
```

### mkdir command

```bash
# Creates a new directory or directories.
mkdir – Creates directories.

# Creates a directory named 'Test'.
- `mkdir Test`

# Creates a nested directory structure.
- `mkdir -p Linux/Ubuntu/Benjn` (creates nested directories).
```

### rmdir command

```bash
# Deletes empty directories.
rmdir – Removes empty directories.

# Removes directories and their parents if they are empty.
- `rmdir -p linux/ubuntu/benjn` (removes multiple levels).
```

### rm command with directories

```bash
## For directories with content, use:

# Deletes a directory and all its contents.
- `rm -r directory_name` (recursively removes contents).

# Forcefully deletes a directory and its contents without confirmation.
- `rm -rf directory_name` (forces deletion without prompts).
```

## Working with Files

### file command

```bash
# File names must match exactly, including case.
- Files are case-sensitive (unlike Windows).

# Directories are a type of file in Linux.
- Directories are treated as files.

# File types are identified by their content, not their names.
- Linux does not determine file type based on extensions.

# Displays the type of a specified file.
file – Identifies file type.

# Shows the file type of 'image.png'.
Example: `file image.png`
```

### touch command

```bash
# Creates new empty files or updates timestamps of existing files.
touch – Creates empty files.

# Creates an empty file named 'file.txt'.
- `touch file.txt`

# Creates multiple empty files.
- `touch file1.txt file2.txt` (creates multiple files).
```

### rm command with files

```bash
# Deletes specified files or directories.
rm – Removes files and directories.

# Removes 'file.txt'.
- `rm file.txt` – Deletes a file.

# Prompts for confirmation before deleting.
- `rm -i file.txt` – Interactive mode (asks for confirmation).

# Deletes a directory and its contents without confirmation.
- `rm -rf directory_name` – Forcefully deletes directories and files.
```

### cp command

```bash
# Duplicates files or directories.
cp – Copies files and directories.

# Copies 'file1.txt' to 'file2.txt'.
- `cp file1.txt file2.txt` (copies a file).

# Copies a directory and its contents.
- `cp -r directory_name directory_copy` (copies a directory).
```

### mv command

```bash
# Moves files or directories to a new location or renames them.
mv – Moves or renames files.

# Renames 'file1.txt' to 'file2.txt'.
- `mv file1.txt file2.txt` (renames a file).

# Moves 'file.txt' to the specified destination.
- `mv file.txt /destination/` (moves a file).

# Renames a directory.
- `mv directory_old directory_new` (renames a directory).
```

## Viewing File Contents

### head command

```bash
# Shows the beginning of a file.
head – Displays the first lines of a file.

# Displays the first 10 lines of 'filename.txt'.
- `head filename.txt` (shows first 10 lines by default).

# Displays the first 5 lines.
- `head -5 filename.txt` (shows first 5 lines).
```

### tail command

```bash
# Shows the end of a file.
tail – Displays the last lines of a file.

# Displays the last 10 lines of 'filename.txt'.
- `tail filename.txt` (shows last 10 lines by default).

# Displays the last 5 lines.
- `tail -5 filename.txt` (shows last 5 lines).
```

### cat command

```bash
# Outputs the contents of one or more files.
cat – Concatenates and displays file contents.

# Displays the entire content of 'file.txt'.
- `cat file.txt` (prints the whole file).

# Displays contents of both files sequentially.
- `cat file1.txt file2.txt` (prints multiple files).

# Copies content from 'file1.txt' to 'file2.txt'.
- `cat file1.txt > file2.txt` (copies content to another file).
```

### echo command

```bash
# Outputs text to the terminal or into a file.
echo – Displays text and writes to a file.

# Writes "Hello World" into 'file.txt'.
- `echo "Hello World" > file.txt` (creates and writes text).

# Appends "Text" to 'file.txt'.
- `echo "Text" >> file.txt` (appends text).
```

### more command

```bash
# Allows viewing large files in segments.
more / less – View file contents page by page.

# Displays 'file.txt' one screen at a time.
- `more file.txt`
```

### less command

```bash
# Displays 'file.txt' with backward scrolling capability.
- `less file.txt` (allows scrolling back).
```

## Linux File System Structure

```bash
Navigate the root directory:

# Changes to the root directory.
cd /

# Displays '/' (the root directory).
pwd

# Lists files and directories in the root.
ls -l
```

## System Information

```bash
# Displays how long the system has been running.
- `uptime` – Shows system runtime.

# Shows current memory usage statistics.
- `free` – Displays memory usage.

# Lists currently running processes.
- `ps` – Shows running processes.

# Shows disk space usage for file systems.
- `df` – Displays disk usage.
```

## Miscelleneous commands

### File Permissions and Ownership

```bash
# Modifies the access permissions of files or directories.
chmod – Changes file permissions.
# Sets the permissions of 'script.sh' to read, write, and execute for the owner, and read and execute for others.
- Example: `chmod 755 script.sh`

# Changes the owner and/or group of a file or directory.
chown – Changes file owner and group.
# Changes the owner of 'file.txt' to 'user' and the group to 'group'.
- Example: `chown user:group file.txt`
```

### Searching and Locating Files

```bash
# Finds specific text in files or output.
grep – Searches for a pattern in files.
# Searches 'file.txt' for 'search_term'.
- Example: `grep "search_term" file.txt`

# Recursively searches for 'pico' in all files in the current directory.  
grep -r "pico" .
# Recursively searches for 'pico' in all files in the specified directory.
grep -r "pico" /path/to/folder/with/nested/files

# Locates files and directories based on specified criteria.
find – Searches for files in a directory hierarchy.
# Finds all .txt files in the specified path.
- Example: `find /path/to/search -name "*.txt"`
```

### Archiving and Downloading Files

```bash
# Combines multiple files or directories into a tarball for easier distribution.
tar – Archives files into a single file.
# Creates a tar file 'archive.tar' containing the specified directory.
- Example: `tar -cvf archive.tar /path/to/directory`

# Retrieves files from the internet via the command line.
wget – Downloads files from the web.
# Downloads 'file.zip' from the specified URL.
- Example: `wget http://example.com/file.zip`
```

### Remote Access and Process Management

```bash
# Allows secure remote access to another computer over a network.
ssh – Secure shell for logging into a remote machine.
# Connects to 'hostname' as 'user' via SSH.
- Example: `ssh user@hostname`

# Lists active processes in the system.
ps – Displays currently running processes.
# Shows detailed information about all running processes.
- Example: `ps aux`

# Terminates or sends signals to processes based on their PID.
kill – Sends a signal to a process.
# Sends the default TERM signal to the process with the specified PID.
- Example: `kill PID`
```

### Administrative Privileges and Disk Usage

```bash
# Allows users to run commands with elevated permissions.
sudo – Executes a command with superuser privileges.
# Runs the command to update package lists with administrative privileges.
- Example: `sudo apt-get update`

# Shows how much disk space is used and available on the mounted file systems.
df – Displays disk space usage.
# Shows disk usage in a human-readable format.
- Example: `df -h`

# Reports the amount of disk space used by files or directories.
du – Displays disk usage of files and directories.
# Shows the total disk usage of the specified directory in a human-readable format.
- Example: `du -sh /path/to/directory`
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
