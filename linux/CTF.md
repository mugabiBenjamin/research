# Essential Tools by Category

- [Web Exploitation](#web-exploitation)
- [Cryptography](#cryptography)
- [Reverse Engineering](#reverse-engineering)
- [Digital Forensics](#digital-forensics)
- [Binary Exploitation](#binary-exploitation)
- [Network Security](#network-security)
- [Programming/Scripting Tools](#programmingscripting-tools)
- [Analysis Utilities](#analysis-utilities)
- [Key Skills to Master](#key-skills-to-master)
- [Winning Strategies](#winning-strategies)
- [Quick Wins Checklist](#quick-wins-checklist)
- [Browser extensions to add](#browser-extensions-to-add)
- [Quick Reference by Challenge Type](#quick-reference-by-challenge-type)
- [Common CTF Workflow](#common-ctf-workflow)

## Web Exploitation

- Browser dev tools
- sqlmap (SQL injection)
- dirb/gobuster (directory enumeration)
- wfuzz (fuzzing)

- **burpsuite** - Web proxy/scanner for intercepting HTTP requests, finding vulnerabilities
- **dirb** - Directory/file brute-forcer to find hidden web paths
- **gobuster** - Fast directory/DNS/vhost brute-forcer
- **wfuzz** - Web application fuzzer for parameters, directories, files
- **sqlmap** - Automated SQL injection detection and exploitation
- **nikto** - Web server scanner for vulnerabilities and misconfigurations

## Cryptography

- CyberChef (encoding/decoding)
- Python cryptography libraries
- John the Ripper/hashcat (password cracking)
- RSACTFTool (RSA attacks)
- sage (advanced crypto math)

- **hashcat** - Advanced password recovery using GPU acceleration
- **john** - John the Ripper password cracker
- **openssl** - Cryptographic toolkit for certificates, hashing, encryption

## Reverse Engineering

- Ghidra/IDA Pro (disassemblers)
- x64dbg/GDB (debuggers)
- strings, file, hexdump (analysis)
- Wireshark (network RE)

- **GDB** - GNU Debugger for debugging programs, analyzing crashes, setting breakpoints
- **pwndbg** - GDB extension with exploit development features
- **radare2** - Reverse engineering framework for disassembly, debugging, analysis
- **ghidra** - NSA's reverse engineering suite with GUI disassembler/decompiler
- **binwalk** - Firmware analysis tool for extracting embedded files
- **strings** - Extract printable strings from binary files
- **file** - Identify file types and formats
- **strace** - Trace system calls made by programs
- **ltrace** - Trace library calls made by programs

## Digital Forensics

- Autopsy/FTK Imager (disk analysis)
- Volatility (memory forensics)
- binwalk (firmware analysis)
- exiftool (metadata)
- Wireshark (network forensics)

- **foremost** - File carving tool to recover deleted files from disk images
- **scalpel** - File carving tool, faster alternative to foremost
- **volatility** - Memory forensics framework for analyzing RAM dumps
- **exiftool** - Read/write metadata in images and other files
- **steghide** - Hide/extract data in image/audio files (steganography)
- **outguess** - Steganography tool for JPEG images

## Binary Exploitation

- GDB with pwndbg/GEF
- pwntools (Python exploitation framework)
- ROPgadget (ROP chain building)
- checksec (binary protections)

## Network Security

- Wireshark/tcpdump
- nmap (scanning)
- netcat (networking)
- Scapy (packet crafting)

- **nmap** - Network scanner for host/service discovery and port scanning
- **netcat** - Network Swiss Army knife for connections, port listening
- **socat** - Advanced netcat with more protocols and features
- **curl/wget** - HTTP clients for web requests and file downloads

## Programming/Scripting Tools

- **pwntools** - Python CTF framework for exploit development
- **requests** - Python HTTP library for web interactions
- **scapy** - Python packet manipulation library
- **cryptography** - Python cryptographic library
- **beautifulsoup4** - Python HTML/XML parser for web scraping

## Analysis Utilities

- **hexdump/xxd** - Display files in hexadecimal format
- **tree** - Display directory structures
- **htop** - Interactive process viewer
- **tmux** - Terminal multiplexer for session management
- **p7zip** - Archive extraction tool for multiple formats

## Key Skills to Master

- **Python scripting** - automate everything
- **Linux command line** - most CTFs run on Linux
- **Common encodings** - base64, hex, URL encoding
- **Web fundamentals** - HTTP, cookies, sessions
- **Assembly basics** - x86/x64 for reversing
- **Cryptography principles** - common attacks and weaknesses

## Winning Strategies

- Start with easy challenges to build momentum and points
- Read challenge descriptions carefully - hints are often embedded
- Check file types first (file command)
- Look for low-hanging fruit - commented code, hidden files, obvious patterns
- Collaborate effectively if team-based
- Document your findings - helps with similar challenges
- Time management - don't get stuck on one challenge too long
- Practice regularly on platforms like `PicoCTF`, `HackTheBox`, `TryHackMe`

## Quick Wins Checklist

- Check source code for comments/hidden elements
- Try common passwords (admin/password, etc.)
- Look for `.git`, `.DS_Store`, backup files
- Test for SQL injection with `'` or `1=1`
- Check for directory traversal (`../../../etc/passwd`)
- Examine image metadata with exiftool
- Use `strings` on binary files
- Check for steganography in images

## Browser extensions to add

- Wappalyzer
- Cookie Editor
- User-Agent Switcher

## Quick Reference by Challenge Type

- **Binary Exploitation:** Start with `file` to identify binary type, use `strings` for quick wins, then `gdb` with breakpoints to analyze crashes.
- **Web Challenges:** Use `burpsuite` to intercept requests, `dirb`/`gobuster` for hidden files, `sqlmap` when you suspect SQL injection.
- **Forensics:** `exiftool` for image metadata, `binwalk` for firmware, `volatility` for memory dumps, `foremost` for file recovery.
- **Crypto:** `hashcat`/`john` for password cracking, `openssl` for encoding/decoding operations.
- **Network:** `nmap` for reconnaissance, `netcat` for connections, `wireshark` for packet analysis.

## Common CTF Workflow

- `file` - identify what you're dealing with
- `strings` - look for obvious flags/hints
- `exiftool` - check metadata on images
- `binwalk` - extract embedded files
- Tool-specific analysis based on challenge type

Most tools have built-in help (`tool --help` or `man tool`) for additional options when you need them during challenges.

[Back to Top](#essential-tools-by-category)
