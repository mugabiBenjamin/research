# ssh

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

## Copy files from remote host

```bash
# Copy file
scp username@ip_address:/path/to/file C:\destination\path

# Copy directory
scp username@ip_address:/path/to/file C:\destination\path
```

[Back to Top](#ssh)
