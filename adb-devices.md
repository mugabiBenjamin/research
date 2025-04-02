# ADB (Android Debug Bridge)

## Installation

```bash
# Install ADB on Linux
sudo apt install adb

Enable USB Debugging on Your Phone:
1. Go to Settings > About phone.
2. Tap Build number 7 times to enable Developer Mode.
3. Go to Developer Options and enable USB Debugging.
```

## Verifcation

```bash
# List connected devices
adb devices

# Output
List of devices attached
0123456789ABCDEF  device


# Device States:
- `device` → Connected and ready for commands.
- `unauthorized` → Approve the connection on the phone.
- `offline` → Device not properly connected.
```

## Device Navigation & File Transfer

```bash
# Open terminal on the device
adb shell

# List files in /sdcard
adb shell ls /sdcard

# Copy file from phone to PC
adb pull /sdcard/path/to/file /path/on/pc

# Copy file from PC to phone
adb push /path/on/pc /sdcard/path/on/phone
```

## Reboot commands

```bash
# Restart device
adb reboot

# Boot into bootloader mode
adb reboot bootloader

# Boot into recovery mode
adb reboot recovery
```

## App management

```bash
# Install an APK
adb install /path/to/app.apk

# Uninstall an app
adb uninstall com.example.app
```

## Debugging & screen capture

```bash
# Capture a bug report
adb bugreport

# Take a screenshot
adb shell screencap /sdcard/screenshot.png

# Transfer screenshot to PC
adb pull /sdcard/screenshot.png /path/on/pc

# Record screen
adb shell screenrecord /sdcard/screenrecord.mp4

# Transfer screen recording to PC
adb pull /sdcard/screenrecord.mp4 /path/on/pc
```

## Port forwarding

```bash
# Forward a local port to a remote port
adb forward tcp:8080 tcp:8080

# Reverse forward a remote port to local
adb reverse tcp:3000 tcp:3000
```

## Backup & restore

```bash
# Backup device data
adb backup -apk -shared -all -f backup.ab

# Restore backup
adb restore backup.ab
```

## Wireless ADB (Without USB)

```bash
1. Enable Wireless Debugging (Android 11+)
2. Go to Developer Options > Wireless Debugging.
3. Toggle Wireless Debugging ON.

# Set device to listen for TCP/IP connections
adb tcpip 5555

Find Device IP
1. Go to Settings > Wi-Fi.
2. Tap the connected network to view IP (e.g., 192.168.1.100).

# Replace <IP_ADDRESS> with actual IP
adb connect <IP_ADDRESS>:5555

# Verify connection
adb devices

# Once connected, you can unplug the USB cable.

# Restart ADB
adb kill-server
adb start-server

# Reconnect to device
adb connect <IP_ADDRESS>:5555

# Ensure both devices are on the same Wi-Fi network.
```

## Pairing Without USB (QR Code / Pairing Code)

```bash
1. Go to Developer Options > Wireless Debugging
2. Tap Pair Device with QR Code or Pair with Code.
3. On your computer, run:

# Enter pairing code from the device
adb pair <IP_ADDRESS>:<PORT>

# Disconnect from device
adb disconnect <IP_ADDRESS>:5555
```
