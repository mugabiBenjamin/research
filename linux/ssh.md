# ssh

- [To install the SSH server](#to-install-the-ssh-server)
- [For better security, disable SSH when not in use](#for-better-security-disable-ssh-when-not-in-use)
- [SSH connection](#ssh-connection)
- [Copy files from remote host](#copy-files-from-remote-host)
- [Find your IP address](#find-your-ip-address)
- [Troubleshooting](#troubleshooting)
- [SSH Keys (passwordless login)](#ssh-keys-passwordless-login)
- [Basic sshd_config hardening](#basic-sshd_config-hardening)
- [If you lock yourself out](#if-you-lock-yourself-out)

## To install the SSH server

```bash
sudo apt update
sudo apt install openssh-server
sudo systemctl start ssh
sudo systemctl enable ssh
```

## For better security, disable SSH when not in use

```bash
sudo systemctl stop ssh
sudo systemctl disable ssh
```

### Keep it running if

- You regularly SSH in remotely
- You use it for automated tasks/backups
- Convenience > minimal risk on your home network

## Disable it if

- You rarely use SSH
- Your laptop travels to untrusted networks
- You want minimal attack surface

## Compromise approach

Keep it enabled but configure /etc/ssh/sshd_config:

- Disable password auth (use SSH keys only)
- Change default port 22
- Use AllowUsers to whitelist specific users
- Enable fail2ban to block brute force attempts

For a personal laptop on home WiFi, the risk is low either way, but disabling when unused is slightly safer.

```bash
# Verify SSH is running:
sudo systemctl status ssh

# Check firewall:
sudo ufw status

# If firewall is active, allow SSH:
sudo ufw allow ssh
```

## SSH connection

```bash
# Connect to remote host
ssh username@ip_address

# Connect on custom port
ssh username@ip_address -p port_number

# Test local SSH
ssh username@localhost
```

## Copy files from remote host

```bash
# Copy file from remote to local
scp username@ip_address:/path/to/file C:\destination\path

# Copy directory from remote to local
scp -r username@ip_address:/path/to/folder C:\destination\path

# Copy file from local to remote
scp C:\local\file username@ip_address:/remote/path

# Copy directory from local to remote
scp -r C:\local\folder username@ip_address:/remote/path

# When using custom port
scp -P PORT_NUMBER username@ip_address:/path/to/file C:\destination\path

C:\Users\Admin> scp -P PORT_NUMBER C:/Users/Admin/Downloads/wordlist_candidates.txt username@ip_address:/home/username/Desktop/UCC/double_trouble/fifth
# -
C:\Users\Admin>scp -P PORT_NUMBER C:\Users\Admin\Downloads\wordlist_candidates.txt username@ip_address:/home/username/Desktop/UCC/double_trouble/sixth
```

## Find your IP address

```bash
# Show all network interfaces
ip address

# Show only IPv4 addresses
ip address | grep "inet "

# Show specific interface (e.g., wlp3s0)
ip address show wlp3s0 | grep "inet "

# Extract just the IP
ip -4 addr show wlp3s0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}'
```

## Troubleshooting

```bash
# Verify SSH is listening on port 22
sudo ss -tlnp | grep :22

# Check SSH service logs
sudo journalctl -u ssh -n 50

# Test firewall rules
sudo ufw status numbered
```

## SSH Keys (passwordless login)

```bash
# Generate SSH key pair (on client)
ssh-keygen -t ed25519 -C "your_email@example.com"

# Copy public key to remote host
ssh-copy-id username@ip_address

# With custom port
ssh-copy-id -p PORT_NUMBER username@ip_address

# Or manually add to remote ~/.ssh/authorized_keys
cat ~/.ssh/id_ed25519.pub | ssh username@ip_address "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
```

## Basic sshd_config hardening

### Step-by-step to avoid lockout

#### 1. Generate SSH key on Windows

```cmd
ssh-keygen -t ed25519 -C "your_email@example.com"
```

Output:

```plain
Generating public/private ed25519 key pair.
Enter file in which to save the key (C:\Users\YourName/.ssh/id_ed25519): [Press Enter]
Enter passphrase (optional): [Press Enter or type passphrase]
```

#### 2. Copy public key to Ubuntu

Option A - One-liner from Windows:

```cmd
type C:\Users\YourName\.ssh\id_ed25519.pub | ssh username@ip_address "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
```

Option B - Manual method:

```cmd
# View your public key on Windows
type C:\Users\YourName\.ssh\id_ed25519.pub
```

Then on Ubuntu:

```bash
mkdir -p ~/.ssh
nano ~/.ssh/authorized_keys
# Paste the key, save with Ctrl+X, Y, Enter
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
```

#### 3. Test key-based login BEFORE disabling passwords

```bash
ssh username@ip_address
# Should connect without asking for password. If it works, you're safe.
```

#### 4. Edit SSH config

```bash
sudo nano /etc/ssh/sshd_config
```

Uncomment and modify these lines:

```plain
Port PORT_NUMBER
PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
AllowUsers username
```

#### 5. Apply changes

```bash
# Reload systemd and restart SSH
sudo systemctl daemon-reload
sudo systemctl restart ssh.socket

# Update firewall for new port
sudo ufw delete allow ssh
sudo ufw allow PORT_NUMBER/tcp
```

#### 6. Connect using new port

```bash
ssh username@ip_address -p PORT_NUMBER
```

## If you lock yourself out

- Physical access required
- Boot into recovery mode or use live USB
- Mount your drive and edit `/etc/ssh/sshd_config`
- Change `PasswordAuthentication` back to `yes`

## Alternatively, use a different method to transfer:

- USB drive
- Shared folder
- Upload to cloud storage and download
- Use `nc` (netcat) for direct transfer

[Back to Top](#ssh)
