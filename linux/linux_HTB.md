# Linux HTB

- [Linux HTB](#linux-htb)
  - [HTB Academy — Linux Fundamentals: Finding Files \& Directories](#htb-academy--linux-fundamentals-finding-files--directories)
  - [HTB Academy — Linux Fundamentals: Filtering \& Enumeration](#htb-academy--linux-fundamentals-filtering--enumeration)
  - [HTB Academy — Linux Fundamentals: Services \& Task Scheduling](#htb-academy--linux-fundamentals-services--task-scheduling)
  - [Remote Desktop Protocols in Linux — HTB Write-Up](#remote-desktop-protocols-in-linux--htb-write-up)

## HTB Academy — Linux Fundamentals: Finding Files & Directories

```bash
## Find inode (index number) of a file
ls -i /etc/sudoers

## Show most recently modified files
ls -lt /var/backups

## Find config files by date and size
find / -type f -name "*.conf" -newermt "2020-03-03" -size +25k -size -28k 2>/dev/null

## Count `.bak` files on the system
find / -type f -name "*.bak" 2>/dev/null | wc -l

## Find full path of a binary
which xxd

## Count installed packages
dpkg -l | wc -l

## Count only installed packages accurately
dpkg -l | grep '^ii' | wc -l

## Count listening IPv4 services excluding localhost
ss -lnt4 | grep -vE "127\.0\.0\." | wc -l

## View listening IPv4 services excluding localhost
ss -lnt4 | grep -vE "127\.0\.0\."
```

## HTB Academy — Linux Fundamentals: Filtering & Enumeration

```bash
# =============================================================

# --- Task 1: Filter unique paths from inlanefreight.com ---
# Goal: Fetch page source and extract unique paths from the domain

curl -s https://www.inlanefreight.com \
  | grep -oP '(?:href|src|action)=["'"'"']\K(https://www\.inlanefreight\.com)?/[^"'"'"' >?#]+' \
  | sed 's|https://www\.inlanefreight\.com||g' \
  | sort -u \
  | wc -l
# Answer: 34

# --- Task 2: Determine what user ProFTPd is running under ---
# SSH into target: 10.129.96.149 | user: htb-student | pass: HTB_@cademy_stdnt!

ps aux | grep proftpd | grep -v grep
# Output: proftpd  6502  0.0  0.1 ... proftpd: (accepting connections)
# Answer: proftpd

# --- Task 3: How many services are listening on all interfaces (IPv4, non-localhost)? ---

ss -ln4 | grep LISTEN | grep -v '127\.' | wc -l
# Answer: 7
```

## HTB Academy — Linux Fundamentals: Services & Task Scheduling

```bash
# =============================================================

# --- Task 1: Find unit with description "Load AppArmor profiles managed internally by snapd" ---

systemctl list-units --type=service | grep -i "snapd"
# Answer: snapd.apparmor.service

# --- Task 2: Determine the Type of dconf.service ---

systemctl show dconf.service
systemctl cat dconf.service
find /etc/systemd /lib/systemd /usr/lib/systemd -name "dconf.service" 2>/dev/null

# Answer: dbus
# Reason: dconf.service uses Type=dbus meaning it is started on-demand via
# D-Bus activation. Systemd only considers the service "ready" once it has
# acquired its bus name (ca.desrt.dconf), rather than on process start.

# --- Systemd Service Types (reference) ---
# simple   - process started immediately, default type
# exec     - like simple, but waits for exec() to complete
# forking  - process forks a child; parent exits
# oneshot  - process must exit before systemd proceeds
# dbus     - started on-demand via D-Bus activation
# notify   - process sends sd_notify() when ready
# idle     - delayed until all jobs are dispatched
```

## Remote Desktop Protocols in Linux — HTB Write-Up

```bash
# ------------------------------------------------------------
# OVERVIEW
# ------------------------------------------------------------
# Two main protocols for graphical remote access:
#   RDP  → Windows environments
#   VNC  → Linux environments (cross-platform)
#
# X11 (XServer) → Native Linux graphical protocol
#   - Renders graphics LOCALLY (saves bandwidth vs VNC/RDP)
#   - Unencrypted by default → must tunnel over SSH
#   - Ports: TCP 6000–6009 (display :0 = port 6000, etc.)
```

---

```bash
# ------------------------------------------------------------
# X11 FORWARDING
# ------------------------------------------------------------
# Check if X11Forwarding is enabled on the target:
cat /etc/ssh/sshd_config | grep X11Forwarding
# Expected: X11Forwarding yes

# Launch a GUI app on the remote machine, rendered locally:
ssh -X htb-student@10.129.23.11 /usr/bin/firefox

# SECURITY NOTE:
# Open X servers (TCP 6000-6010) are a red flag on Linux targets
# Attackers can capture X window contents using:
#   xwd       → screenshots of X windows
#   xgrabsc   → screen grab tool
# No sniffing needed — X11 exposes window data directly

# Known vulns: CVE-2017-2624, CVE-2017-2625, CVE-2017-2626
#   → weak session keys in XOrg → arbitrary code execution
```

---

```bash
# ------------------------------------------------------------
# XDMCP
# ------------------------------------------------------------
# X Display Manager Control Protocol
#   - UDP port 177
#   - Manages remote X Window sessions (full GUI like KDE/GNOME)
#   - INSECURE — vulnerable to MITM attacks
#   - Avoid in any security-sensitive environment
```

---

```bash
# ------------------------------------------------------------
# VNC — SETUP & CONNECTION
# ------------------------------------------------------------
# VNC default port: TCP 5900 (display :0)
# Additional sessions: 5901 (:1), 5902 (:2), etc.

# --- Install TigerVNC + XFCE4 (GNOME is unstable with VNC) ---
sudo apt install xfce4 xfce4-goodies tigervnc-standalone-server -y
vncpasswd                          # set VNC password

# --- Configure xstartup ---
touch ~/.vnc/xstartup ~/.vnc/config

cat <<EOT >> ~/.vnc/xstartup
#!/bin/bash
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
/usr/bin/startxfce4
[ -x /etc/vnc/xstartup ] && exec /etc/vnc/xstartup
[ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources
x-window-manager &
EOT

cat <<EOT >> ~/.vnc/config
geometry=1920x1080
dpi=96
EOT

chmod +x ~/.vnc/xstartup            # make xstartup executable

# --- Start VNC server ---
vncserver                           # spawns display :1 on port 5901

# --- List active VNC sessions ---
vncserver -list
# Output shows: DISPLAY | PORT | PID
```

---

```bash
# ------------------------------------------------------------
# SECURING VNC WITH SSH TUNNEL
# ------------------------------------------------------------
# VNC traffic should NEVER go raw over a network
# Tunnel it through SSH:

ssh -L 5901:127.0.0.1:5901 -N -f -l htb-student 10.129.14.130
#    -L → local port forward (local 5901 → remote 5901)
#    -N → no command, just tunnel
#    -f → run in background

# --- Connect via tunnel ---
xtightvncviewer localhost:5901
# Enter VNC password when prompted
# You now have an encrypted graphical session
```

---

```bash
# ------------------------------------------------------------
# QUICK REFERENCE — PORTS TO NOTE ON LINUX TARGETS
# ------------------------------------------------------------
# 177/UDP   → XDMCP    (insecure, full GUI redirect)
# 5900/TCP  → VNC :0
# 5901/TCP  → VNC :1   (most common after setup)
# 6000/TCP  → X11 :0
# 6001-6009 → X11 :1–:9
```

[Back to Top](#linux-htb)
