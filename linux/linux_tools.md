# Specialized Linux Tools Reference

## Table of Contents

1. [File Analysis & Forensics](#file-analysis--forensics)
2. [Network Analysis](#network-analysis)
3. [System Monitoring & Debugging](#system-monitoring--debugging)
4. [Disk & File Recovery](#disk--file-recovery)
5. [Archive & Compression](#archive--compression)
6. [Media Analysis](#media-analysis)
7. [Security & Cryptography](#security--cryptography)
8. [Performance Analysis](#performance-analysis)
9. [Text Processing & Data](#text-processing--data)
10. [Network Security](#network-security)
11. [Forensics](#forensics)
12. [Web Security](#web-security)
13. [System Analysis](#system-analysis)

## File Analysis & Forensics

### hexdump - Hexadecimal File Viewer

```bash
# Display hex and ASCII
hexdump -C file.bin

# Display only hex
hexdump -x file.bin

# Display specific number of bytes
hexdump -C -n 256 file.bin

# Display with custom format
hexdump -e '16/1 "%02x " "\n"' file.bin
```

### xxd - Hex Dump with Reverse Capability

```bash
# Create hex dump
xxd file.bin

# Limit output lines
xxd -l 100 file.bin

# Create C array format
xxd -i file.bin

# Reverse hex dump to binary
xxd -r hexdump.txt binary.bin

# Skip bytes
xxd -s 1024 file.bin
```

### binwalk - Firmware Analysis Tool

```bash
# Analyze file for embedded data
binwalk firmware.bin

# Extract embedded files
binwalk -e firmware.bin

# Recursive extraction
binwalk -Me firmware.bin

# Entropy analysis
binwalk -E firmware.bin

# Signature scan only
binwalk -B firmware.bin
```

### foremost - File Recovery Tool (Extract embedded files)

```bash
# Recover files from disk image (Default)
foremost -i disk.img -o output/

# Specify file types
foremost -t jpg,png,pdf -i disk.img -o recovery/

# Use configuration file
foremost -c foremost.conf -i disk.img -o output/

# Verbose output
foremost -v -i disk.img -o output/
```

### file - Enhanced File Type Detection

```bash
# Basic file type
file document.pdf

# MIME type
file -i document.pdf

# Don't follow symlinks
file -h symlink

# Brief output
file -b file.txt

# Check compressed files
file -z archive.tar.gz
```

### exiftool - Metadata Extraction/Manipulation

```bash
# View all metadata
exiftool image.jpg

# View specific tags
exiftool -DateTimeOriginal -GPS* photo.jpg

# Remove all metadata
exiftool -all image.jpg

# Copy metadata between files
exiftool -TagsFromFile source.jpg target.jpg

# Batch process directory
exiftool -r -DateTimeOriginal directory/

# Write metadata
exiftool -Artist="John Doe" image.jpg

# Generate CSV report
exiftool -csv directory/ > metadata.csv
```

### strings - Extract Readable Strings

```bash
# Extract strings from binary
strings /bin/ls

# Minimum string length
strings -n 10 binary_file

# Show byte offsets
strings -o executable

# Search for specific strings
strings binary_file | grep -i password

# Different encodings
strings -e l binary_file  # 16-bit little endian
strings -e b binary_file  # 16-bit big endian
```

## upx - Executable Compressor

```bash
# Compress executable
upx program 

# Decompress executable
upx -d program

# Check compression status
upx -t program

# Set compression level (0-9)
upx -9 program
```

## Network Analysis

### tcpdump - Network Packet Capture

```bash
# Capture all traffic on interface
tcpdump -i eth0

# Capture specific host
tcpdump -i eth0 host google.com

# Capture specific port
tcpdump -i eth0 port 80

# Save to file
tcpdump -i eth0 -w capture.pcap

# Read from file
tcpdump -r capture.pcap

# Verbose output with headers
tcpdump -v -i eth0

# Show ASCII content
tcpdump -A -i eth0 port 80

# Filter by protocol
tcpdump -i eth0 tcp
tcpdump -i eth0 udp
tcpdump -i eth0 icmp
```

### nmap - Network Discovery and Security Auditing

```bash
# Basic scan
nmap target.com

# Scan IP range
nmap 192.168.1.1-100

# SYN scan (stealth)
nmap -sS target.com

# UDP scan
nmap -sU target.com

# OS detection
nmap -O target.com

# Service version detection
nmap -sV target.com

# Aggressive scan
nmap -A target.com

# Scan specific ports
nmap -p 80,443,8080 target.com

# Scan all ports
nmap -p- target.com

# Output to file
nmap -oN scan_results.txt target.com
```

### netstat - Network Connections and Statistics

```bash
# Show all connections
netstat -a

# Show listening ports only
netstat -l

# Show TCP connections
netstat -t

# Show UDP connections
netstat -u

# Show process names/PIDs
netstat -p

# Show numerical addresses
netstat -n

# Continuous monitoring
netstat -c

# Show routing table
netstat -r

# Show network statistics
netstat -s
```

### ss - Socket Statistics (netstat replacement)

```bash
# Show all sockets
ss -a

# Show listening sockets
ss -l

# Show TCP sockets
ss -t

# Show UDP sockets
ss -u

# Show process information
ss -p

# Show summary statistics
ss -s

# Filter by port
ss -ln sport :80
```

### wireshark/tshark - Advanced Packet Analysis

```bash
# Command-line wireshark
tshark -i eth0

# Capture to file
tshark -i eth0 -w capture.pcap

# Read from file
tshark -r capture.pcap

# Filter packets
tshark -i eth0 -f "port 80"

# Display filter
tshark -r capture.pcap -Y "http"

# Convert to XML
tshark -r capture.pcap -Y "http" -T dpml > http_pdml.xml
cat http_pdml.xml | grep pass:

# Extract specific fields
tshark -r capture.pcap -T fields -e ip.src -e ip.dst
```

## System Monitoring & Debugging

### lsof - List Open Files

```bash
# List all open files
lsof

# Files opened by specific user
lsof -u username

# Files opened by specific process
lsof -p PID

# What's using a specific file
lsof /path/to/file

# Network connections
lsof -i

# Specific port usage
lsof -i :80

# Files in specific directory
lsof +D /var/log/

# Deleted but still open files
lsof | grep deleted
```

### strace - System Call Tracer

```bash
# Trace all system calls
strace ./program

# Trace specific system calls
strace -e trace=open,read,write ./program

# Trace file operations only
strace -e trace=file ./program

# Trace network operations
strace -e trace=network ./program

# Attach to running process
strace -p PID

# Follow child processes
strace -f ./program

# Save output to file
strace -o trace.log ./program

# Show timestamps
strace -t ./program
```

### ltrace - Library Call Tracer

```bash
# Trace library calls
ltrace ./program

# Trace specific functions
ltrace -e malloc,free ./program

# Attach to running process
ltrace -p PID

# Follow child processes
ltrace -f ./program

# Show timestamps
ltrace -t ./program

# Save to file
ltrace -o trace.log ./program
```

### iotop - I/O Monitor

```bash
# Monitor I/O usage
iotop

# Show processes only
iotop -o

# Show accumulated I/O
iotop -a

# Non-interactive mode
iotop -b -n 1
```

### iostat - I/O Statistics

```bash
# Show I/O statistics
iostat

# Update every 2 seconds
iostat 2

# Show extended statistics
iostat -x

# Show specific device
iostat -x sda

# Human readable
iostat -h
```

## Disk & File Recovery

### ddrescue - Data Recovery Tool

```bash
# Basic recovery
ddrescue /dev/sda backup.img logfile

# Reverse direction recovery
ddrescue -R /dev/sda backup.img logfile

# Direct disc access
ddrescue -d /dev/sda backup.img logfile

# Split damaged areas
ddrescue -S /dev/sda backup.img logfile

# Resume recovery
ddrescue -r3 /dev/sda backup.img logfile
```

### photorec - Photo Recovery Tool

```bash
# Recover files from device
photorec /dev/sdb

# Recover specific file types
photorec /dev/sdb

# Command line mode
photorec /d recovery_dir /dev/sdb
```

### testdisk - Partition Recovery Tool

```bash
# Analyze and recover partitions
testdisk /dev/sda

# Log everything
testdisk /log /dev/sda

# List partitions
testdisk /list /dev/sda
```

### fsck - File System Check

```bash
# Check filesystem
fsck /dev/sda1

# Force check even if clean
fsck -f /dev/sda1

# Automatically repair
fsck -y /dev/sda1

# Check all filesystems
fsck -A

# Dry run (don't fix)
fsck -n /dev/sda1

# Verbose output
fsck -v /dev/sda1
```

### badblocks - Check for Bad Sectors

```bash
# Read-only test
badblocks /dev/sda

# Write test (destructive)
badblocks -w /dev/sda

# Verbose output
badblocks -v /dev/sda

# Show progress
badblocks -s /dev/sda

# Save bad blocks list
badblocks -o badblocks.txt /dev/sda
```

## Archive & Compression

### 7z - 7-Zip Archiver

```bash
# Create archive
7z a archive.7z file1 file2 directory/

# Extract archive
7z x archive.7z

# List contents
7z l archive.7z

# Test archive integrity
7z t archive.7z

# Update archive
7z u archive.7z newfile.txt

# Create password-protected archive
7z a -p archive.7z files/

# Set compression level
7z a -mx9 archive.7z files/
```

### zcat/zless/zgrep - Compressed File Tools

```bash
# View compressed file
zcat file.gz

# Page through compressed file
zless file.gz

# Search in compressed file
zgrep "pattern" file.gz

# View multiple compressed files
zcat file1.gz file2.gz

# Pipe to other commands
zcat logfile.gz | grep ERROR
```

### rar/unrar - RAR Archive Tools

```bash
# Create RAR archive
rar a archive.rar files/

# Extract RAR archive
unrar x archive.rar

# List RAR contents
unrar l archive.rar

# Test RAR archive
unrar t archive.rar

# Extract to specific directory
unrar x archive.rar /destination/
```

## Media Analysis

### ffprobe - Multimedia Stream Analyzer

```bash
# Show file information
ffprobe video.mp4

# Show format information only
ffprobe -show_format video.mp4

# Show stream information
ffprobe -show_streams video.mp4

# JSON output
ffprobe -print_format json video.mp4

# Quiet mode
ffprobe -v quiet -show_format video.mp4

# Specific stream info
ffprobe -select_streams v:0 -show_entries stream=codec_name,width,height video.mp4
```

### mediainfo - Media File Information

```bash
# Show media information
mediainfo movie.mkv

# XML output
mediainfo --Output=XML movie.mkv

# Specific information
mediainfo --Inform="Video;%Width%x%Height%" movie.mkv

# Template output
mediainfo --Template="Duration: $Duration$" audio.mp3

# Batch process
mediainfo *.mp4
```

### identify - Image Information (ImageMagick)

```bash
# Show image info
identify image.jpg

# Verbose information
identify -verbose image.jpg

# Specific format
identify -format "%wx%h" image.jpg

# Batch process
identify *.jpg

# Check image integrity
identify -regard-warnings image.jpg
```

### soxi - Audio File Information

```bash
# Show audio info
soxi audio.wav

# Specific information
soxi -d audio.wav  # Duration
soxi -r audio.wav  # Sample rate
soxi -c audio.wav  # Channels
soxi -b audio.wav  # Bit depth

# Batch process
soxi *.wav
```

## Security & Cryptography

### gpg - GNU Privacy Guard

```bash
# Generate key pair
gpg --gen-key

# List keys
gpg --list-keys

# Encrypt file
gpg -e -r recipient file.txt

# Decrypt file
gpg -d file.txt.gpg

# Sign file
gpg -s file.txt

# Verify signature
gpg --verify file.txt.gpg

# Export public key
gpg --export -a "User Name" > public.key
```

### openssl - SSL/TLS Toolkit

```bash
# Generate private key
openssl genrsa -out private.key 2048

# Generate certificate request
openssl req -new -key private.key -out request.csr

# Generate self-signed certificate
openssl req -x509 -new -key private.key -out certificate.crt

# View certificate
openssl x509 -in certificate.crt -text

# Test SSL connection
openssl s_client -connect google.com:443

# Encrypt file
openssl enc -aes-256-cbc -in file.txt -out file.enc

# Decrypt file
openssl enc -d -aes-256-cbc -in file.enc -out file.txt
```

### sha256sum/md5sum - Hash Calculation

```bash
# Calculate SHA256 hash
sha256sum file.txt

# Calculate MD5 hash
md5sum file.txt

# Verify hash
sha256sum -c checksums.txt

# Create hash file
sha256sum *.txt > checksums.txt

# Batch calculate
find . -type f -exec sha256sum {} \;
```

## Performance Analysis

### perf - Performance Analysis Tools

```bash
# Profile system
perf top

# Record performance data
perf record ./program

# Analyze recorded data
perf report

# Show system statistics
perf stat ./program

# Trace system calls
perf trace ./program

# List available events
perf list
```

### valgrind - Memory Error Detector

```bash
# Check for memory leaks
valgrind --leak-check=full ./program

# Check for memory errors
valgrind --tool=memcheck ./program

# Cache profiling
valgrind --tool=cachegrind ./program

# Call graph profiling
valgrind --tool=callgrind ./program

# Heap profiling
valgrind --tool=massif ./program
```

### gprof - Profiling Tool

```bash
# Compile with profiling
gcc -pg -o program program.c

# Run program (generates gmon.out)
./program

# Generate profile report
gprof program gmon.out > profile.txt

# Flat profile only
gprof -p program gmon.out

# Call graph only
gprof -q program gmon.out
```

## Text Processing & Data

### jq - JSON Processor

```bash
# Pretty print JSON
jq '.' file.json

# Extract specific field
jq '.fieldname' file.json

# Filter arrays
jq '.[] | select(.age > 25)' file.json

# Transform data
jq '.users | map(.name)' file.json

# Raw output (no quotes)
jq -r '.name' file.json

# Compact output
jq -c '.' file.json
```

### csvtool - CSV File Processor

```bash
# Display CSV in columns
csvtool readable file.csv

# Extract specific columns
csvtool col 1,3,5 file.csv

# Convert to different format
csvtool tab file.csv

# Count rows
csvtool height file.csv

# Transpose CSV
csvtool transpose file.csv
```

### xmlstarlet - XML Processor

```bash
# Format XML
xmlstarlet fo file.xml

# Select elements
xmlstarlet sel -t -v "//element" file.xml

# Edit XML
xmlstarlet ed -u "//element" -v "new_value" file.xml

# Validate XML
xmlstarlet val file.xml

# Transform with XSLT
xmlstarlet tr stylesheet.xsl file.xml
```

### pandoc - Document Converter

```bash
# Convert markdown to HTML
pandoc file.md -o file.html

# Convert to PDF
pandoc file.md -o file.pdf

# Convert between formats
pandoc file.docx -o file.txt

# Custom templates
pandoc file.md --template=custom.html -o file.html

# Table of contents
pandoc file.md --toc -o file.html
```

## Network Security

```bash
# ncat - Enhanced netcat
ncat -lvp 4444              # Listener
ncat target.com 80          # Connect

# hydra - Password cracking
hydra -l admin -P passwords.txt ssh://target.com

# john - Password cracking
john --wordlist=rockyou.txt hashes.txt

# hashcat - GPU password cracking
hashcat -m 1000 hashes.txt wordlist.txt
```

## Forensics

```bash
# volatility - Memory forensics
volatility -f memory.dump imageinfo
volatility -f memory.dump pslist

# sleuthkit - Disk forensics
fls disk.img                # List files
icat disk.img 12345         # Extract file by inode

# autopsy - GUI forensics platform
autopsy &

# zsteg - PNG/BMP steganography detection
zsteg image.png              # Detect hidden data
zsteg -a image.png           # All detection methods
zsteg image.png -E b1,lsb,xy # Extract specific bits
```

## Web Security

```bash
# nikto - Web vulnerability scanner
nikto -h http://target.com

# dirb/gobuster - Directory enumeration
dirb http://target.com
gobuster dir -u http://target.com -w wordlist.txt

# sqlmap - SQL injection
sqlmap -u "http://target.com/page?id=1" --dbs
```

## System Analysis

```bash
# chkrootkit - Rootkit detection
chkrootkit

# rkhunter - Rootkit hunter
rkhunter --check

# lynis - Security auditing
lynis audit system

# aide - File integrity checker
aide --init
aide --check
```

[Back to Top](#specialized-linux-tools-reference)
