# SSH Setup Guide - Linux & Windows

## Table of Contents

- [Overview](#overview)
- [Scenario 1: Linux Server + Windows Client](#scenario-1-linux-server--windows-client)
- [Scenario 2: Windows Server + Linux Client](#scenario-2-windows-server--linux-client)
- [Common Operations](#common-operations)
- [Security Best Practices](#security-best-practices)
- [Troubleshooting](#troubleshooting)

## Overview

This guide covers SSH setup for both directions:

- **Scenario 1**: Linux machine as SSH server, Windows as client
- **Scenario 2**: Windows machine as SSH server, Linux as client

## Scenario 1: Linux Server + Windows Client

### Install SSH Server on Linux

```bash
sudo apt update
sudo apt install openssh-server
sudo systemctl start ssh
sudo systemctl enable ssh

# Verify SSH is running
sudo systemctl status ssh

# Configure firewall
sudo ufw allow ssh
```

### Connect from Windows

```cmd
# Basic connection
ssh username@ip_address

# Custom port
ssh username@ip_address -p PORT_NUMBER

# Test local connection (on Linux)
ssh username@localhost
```

### Copy Files (Windows ↔ Linux)

```cmd
# From Windows to Linux
scp C:\local\file username@ip_address:/remote/path
scp -r C:\local\folder username@ip_address:/remote/path

# From Linux to Windows
scp username@ip_address:/path/to/file C:\destination\path
scp -r username@ip_address:/path/to/folder C:\destination\path

# With custom port
scp -P PORT_NUMBER C:\local\file username@ip_address:/remote/path
```

### Setup Passwordless Login (Windows → Linux)

**1. Generate key on Windows:**

```cmd
ssh-keygen -t ed25519 -C "your_email@example.com"
```

**2. Copy key to Linux:**

```cmd
type C:\Users\YourName\.ssh\id_ed25519.pub | ssh username@ip_address "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
```

**3. Test before hardening:**

```cmd
ssh username@ip_address
# Should connect without password
```

### Harden Linux SSH Server

**1. Edit SSH config:**

```bash
sudo nano /etc/ssh/sshd_config
```

**2. Modify these lines:**

```plaintext
Port PORT_NUMBER
PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
AllowUsers username
```

**3. Apply changes:**

```bash
sudo systemctl restart ssh
sudo ufw delete allow ssh
sudo ufw allow PORT_NUMBER/tcp
```

### VS Code Remote-SSH (Windows → Linux)

**1. Create SSH config** (`C:\Users\Admin\.ssh\config`):

```plaintext
Host linux_server
  HostName ip_address
  User username
  Port PORT_NUMBER
```

**2. Connect via VS Code:**

- Install "Remote - SSH" extension
- Press `Ctrl+Shift+P` → "Remote-SSH: Connect to Host"
- Select `linux_server`
- Open folder: `/home/username/Desktop`

## Scenario 2: Windows Server + Linux Client

### Install OpenSSH Server on Windows

#### Method 1: Settings GUI**

1. Settings → Apps → Optional Features
2. Add a feature → OpenSSH Server
3. Install

#### Method 2: PowerShell (Admin)**

```powershell
# Let PowerShell find the exact name automatically
Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH.Server*'

PS C:\WINDOWS\system32> Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH.Server*'

Name  : OpenSSH.Server~~~~0.0.1.0
State : Installed
```

```powershell
# Then install (PowerShell will auto-complete the version)
Add-WindowsCapability -Online -Name OpenSSH.Server*

# Or specify full name
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
```

### Start and Configure SSH Service

```powershell
# Start SSH service
Start-Service sshd

# Set to start automatically
Set-Service -Name sshd -StartupType 'Automatic'

# Configure firewall
New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
```

### Connect from Linux

```bash
# Basic connection
ssh username@windows_ip_address

# Custom port
ssh username@windows_ip_address -p PORT_NUMBER

# First connection will ask to verify host fingerprint
```

### Copy Files (Linux ↔ Windows)

```bash
# From Linux to Windows
scp /local/file username@windows_ip:/C:/destination/path
scp -r /local/folder username@windows_ip:/C:/Users/username/Desktop

# From Windows to Linux
scp username@windows_ip:/C:/path/to/file /local/destination
scp -r username@windows_ip:/C:/path/to/folder /local/destination

# With custom port
scp -P PORT_NUMBER /local/file username@windows_ip:/C:/destination/path
```

**Note:** Windows paths in SSH use forward slashes: `/C:/Users/...`

### Setup Passwordless Login (Linux → Windows)

**1. Generate key on Linux:**

```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
```

**2. Copy key to Windows:**

Option A - Automated:

```bash
ssh-copy-id username@windows_ip_address
```

Option B - Manual:

```bash
# Display your public key
cat ~/.ssh/id_ed25519.pub

# On Windows, create .ssh folder if needed
mkdir C:\Users\username\.ssh

# Add key to authorized_keys
notepad C:\Users\username\.ssh\authorized_keys
# Paste the public key, save
```

**3. Set permissions on Windows (PowerShell Admin):**

```powershell
icacls C:\Users\username\.ssh\authorized_keys /inheritance:r
icacls C:\Users\username\.ssh\authorized_keys /grant:r "username:R"
```

**4. Test connection:**

```bash
ssh username@windows_ip_address
# Should connect without password
```

### Harden Windows SSH Server

**1. Edit SSH config:**

```powershell
notepad C:\ProgramData\ssh\sshd_config
```

**2. Modify these lines:**

```plaintext
Port PORT_NUMBER
PasswordAuthentication no
PubkeyAuthentication yes
```

**3. For admin users, edit:**

```powershell
notepad C:\ProgramData\ssh\administrators_authorized_keys
```

Add your public key here (instead of user's .ssh folder).

**4. Apply changes:**

```powershell
Restart-Service sshd

# Update firewall for new port
Remove-NetFirewallRule -Name sshd
New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort PORT_NUMBER
```

### VS Code Remote-SSH (Linux → Windows)

**1. Create SSH config** (`~/.ssh/config`):

```plaintext
Host windows_server
  HostName windows_ip_address
  User username
  Port PORT_NUMBER
```

**2. Connect via VS Code on Linux:**

- Install "Remote - SSH" extension
- Press `Ctrl+Shift+P` → "Remote-SSH: Connect to Host"
- Select `windows_server`
- Open folder: `/C:/Users/username/Desktop`

## Common Operations

### Find IP Address

**Linux:**

```bash
ip address | grep "inet "
ip -4 addr show wlp3s0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}'
```

**Windows:**

```cmd
ipconfig | findstr IPv4
```

```powershell
Get-NetIPAddress -AddressFamily IPv4 | Select-Object IPAddress
```

### Manage SSH Service

**Linux:**

```bash
sudo systemctl start ssh      # Start
sudo systemctl stop ssh       # Stop
sudo systemctl restart ssh    # Restart
sudo systemctl status ssh     # Check status
sudo systemctl enable ssh     # Auto-start on boot
sudo systemctl disable ssh    # Disable auto-start
```

**Windows (PowerShell Admin):**

```powershell
Start-Service sshd           # Start
Stop-Service sshd            # Stop
Restart-Service sshd         # Restart
Get-Service sshd             # Check status
Set-Service -Name sshd -StartupType 'Automatic'  # Auto-start
Set-Service -Name sshd -StartupType 'Disabled'   # Disable
```

### Add Passphrase to Private Key

**Windows:**

```cmd
ssh-keygen -p -f C:\Users\Admin\.ssh\id_ed25519
```

**Linux:**

```bash
ssh-keygen -p -f ~/.ssh/id_ed25519
```

## Security Best Practices

### When to Disable SSH

**Keep running if:**

- Regular remote access needed
- Automated tasks/backups configured
- On trusted home network with good security

**Disable when:**

- Rarely used
- Laptop on untrusted networks (coffee shops, travel)
- Maximum security required

### Compromise Approach

Keep enabled but harden configuration:

- ✅ Disable password authentication (keys only)
- ✅ Change default port 22
- ✅ Use AllowUsers/DenyUsers whitelist
- ✅ Install fail2ban (Linux) to block brute force
- ✅ Use strong passphrases on private keys
- ✅ Keep SSH software updated

### Key Security

**Private key protection:**

- Never share `id_ed25519` file
- Don't commit to git repositories
- Back up securely (encrypted drive/password manager)
- Use strong passphrase

## Troubleshooting

### Verify SSH is Listening

**Linux:**

```bash
sudo ss -tlnp | grep :22
sudo journalctl -u ssh -n 50
```

**Windows (PowerShell Admin):**

```powershell
Get-NetTCPConnection | Where-Object LocalPort -eq 22
Get-EventLog -LogName Application -Source sshd -Newest 50
```

### Connection Issues

```bash
# Test with verbose output
ssh -v username@ip_address

# Test with very verbose output
ssh -vvv username@ip_address
```

### Firewall Check

**Linux:**

```bash
sudo ufw status numbered
```

**Windows (PowerShell Admin):**

```powershell
Get-NetFirewallRule -Name sshd
```

### Locked Out Recovery

**If you lock yourself out:**

**Linux:**

- Physical access required
- Boot into recovery mode or live USB
- Mount drive and edit `/etc/ssh/sshd_config`
- Change `PasswordAuthentication yes`

**Windows:**

- Physical access required
- Edit `C:\ProgramData\ssh\sshd_config`
- Change `PasswordAuthentication yes`
- Restart sshd service

### Alternative File Transfer Methods

If SSH is unavailable:

- USB drive
- Shared network folder (SMB/CIFS)
- Cloud storage (Google Drive, Dropbox)
- Direct transfer with `nc` (netcat)
- Python HTTP server

## Quick Reference

| Task               | Linux                        | Windows                                             |
| ------------------ | ---------------------------- | --------------------------------------------------- |
| Install SSH server | `apt install openssh-server` | Settings → Optional Features                        |
| Start SSH          | `systemctl start ssh`        | `Start-Service sshd`                                |
| Config location    | `/etc/ssh/sshd_config`       | `C:\ProgramData\ssh\sshd_config`                    |
| User keys          | `~/.ssh/authorized_keys`     | `C:\Users\user\.ssh\authorized_keys`                |
| Admin keys         | N/A                          | `C:\ProgramData\ssh\administrators_authorized_keys` |
| Restart service    | `systemctl restart ssh`      | `Restart-Service sshd`                              |
| Default port       | 22                           | 22                                                  |

[Back to Top](#ssh-setup-guide---linux--windows)
