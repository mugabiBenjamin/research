# Linux

## Working with Directories

```bash
# Shows help documentation for a specified command.
man – Displays the manual for a command.

# Displays the manual for the 'ls' command.
- Example: `man ls`



# Outputs the path of the current directory.
pwd – Prints the current working directory.



# Changes the current directory to a specified path.
cd – Changes directory.

# Navigates to the user's home directory.
- `cd` (without arguments) returns to the home directory.

# Switches back to the previous directory.
- `cd -` toggles between the last two directories.

# Can use full paths or paths relative to the current directory.
- Supports absolute and relative paths.



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



# Creates a new directory or directories.
mkdir – Creates directories.

# Creates a directory named 'Test'.
- `mkdir Test`

# Creates a nested directory structure.
- `mkdir -p Linux/Ubuntu/Benjn` (creates nested directories).



# Deletes empty directories.
rmdir – Removes empty directories.

# Removes directories and their parents if they are empty.
- `rmdir -p linux/ubuntu/benjn` (removes multiple levels).



For directories with content, use:

# Deletes a directory and all its contents.
- `rm -r directory_name` (recursively removes contents).

# Forcefully deletes a directory and its contents without confirmation.
- `rm -rf directory_name` (forces deletion without prompts).
```

## Working with Files

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



# Creates new empty files or updates timestamps of existing files.
touch – Creates empty files.

# Creates an empty file named 'file.txt'.
- `touch file.txt`

# Creates multiple empty files.
- `touch file1.txt file2.txt` (creates multiple files).



# Deletes specified files or directories.
rm – Removes files and directories.

# Removes 'file.txt'.
- `rm file.txt` – Deletes a file.

# Prompts for confirmation before deleting.
- `rm -i file.txt` – Interactive mode (asks for confirmation).

# Deletes a directory and its contents without confirmation.
- `rm -rf directory_name` – Forcefully deletes directories and files.



# Duplicates files or directories.
cp – Copies files and directories.

# Copies 'file1.txt' to 'file2.txt'.
- `cp file1.txt file2.txt` (copies a file).

# Copies a directory and its contents.
- `cp -r directory_name directory_copy` (copies a directory).



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

```bash
# Shows the beginning of a file.
head – Displays the first lines of a file.

# Displays the first 10 lines of 'filename.txt'.
- `head filename.txt` (shows first 10 lines by default).

# Displays the first 5 lines.
- `head -5 filename.txt` (shows first 5 lines).



# Shows the end of a file.
tail – Displays the last lines of a file.

# Displays the last 10 lines of 'filename.txt'.
- `tail filename.txt` (shows last 10 lines by default).

# Displays the last 5 lines.
- `tail -5 filename.txt` (shows last 5 lines).



# Outputs the contents of one or more files.
cat – Concatenates and displays file contents.

# Displays the entire content of 'file.txt'.
- `cat file.txt` (prints the whole file).

# Displays contents of both files sequentially.
- `cat file1.txt file2.txt` (prints multiple files).

# Copies content from 'file1.txt' to 'file2.txt'.
- `cat file1.txt > file2.txt` (copies content to another file).



# Outputs text to the terminal or into a file.
echo – Displays text and writes to a file.

# Writes "Hello World" into 'file.txt'.
- `echo "Hello World" > file.txt` (creates and writes text).

# Appends "Text" to 'file.txt'.
- `echo "Text" >> file.txt` (appends text).


# Allows viewing large files in segments.
more / less – View file contents page by page.

# Displays 'file.txt' one screen at a time.
- `more file.txt`



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

##

```bash

# Modifies the access permissions of files or directories.
chmod – Changes file permissions.
# Sets the permissions of 'script.sh' to read, write, and execute for the owner, and read and execute for others.
- Example: `chmod 755 script.sh`

# Changes the owner and/or group of a file or directory.
chown – Changes file owner and group.
# Changes the owner of 'file.txt' to 'user' and the group to 'group'.
- Example: `chown user:group file.txt`

# Finds specific text in files or output.
grep – Searches for a pattern in files.
# Searches 'file.txt' for 'search_term'.
- Example: `grep "search_term" file.txt`

# Locates files and directories based on specified criteria.
find – Searches for files in a directory hierarchy.
# Finds all .txt files in the specified path.
- Example: `find /path/to/search -name "*.txt"`

# Combines multiple files or directories into a tarball for easier distribution.
tar – Archives files into a single file.
# Creates a tar file 'archive.tar' containing the specified directory.
- Example: `tar -cvf archive.tar /path/to/directory`

# Retrieves files from the internet via the command line.
wget – Downloads files from the web.
# Downloads 'file.zip' from the specified URL.
- Example: `wget http://example.com/file.zip`

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
