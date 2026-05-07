# Linux HTB

- [Linux HTB](#linux-htb)
  - [HTB Academy — Linux Fundamentals: Finding Files \& Directories](#htb-academy--linux-fundamentals-finding-files--directories)
  - [HTB Academy — Linux Fundamentals: Filtering \& Enumeration](#htb-academy--linux-fundamentals-filtering--enumeration)
  - [HTB Academy — Linux Fundamentals: Services \& Task Scheduling](#htb-academy--linux-fundamentals-services--task-scheduling)

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

[Back to Top](#linux-htb)
