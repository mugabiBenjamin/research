# Wifi commands

- [Show all available networks in range](#show-all-available-networks-in-range)
- [Show active wifi](#show-active-wifi)
- [Display QR code for active network](#display-qr-code-for-active-network)
- [Show all coonections whether currently active or not](#show-all-coonections-whether-currently-active-or-not)
- [Low-level WiFi tools](#low-level-wifi-tools)

## Show all available networks in range

```bash
# show only WiFi networks that are currently broadcasting in range
nmcli dev wifi list

# show wifi password of wifi
sudo nmcli -s -g 802-11-WIRELESS-SECURITY.PSK connection show "SSID"
```

## Show active wifi

```bash
# show active wifi
nmcli connection show --active

# alternatively
nmcli c show --active
```

## Display QR code for active network

```bash
# display password and qrcode of currently connected network
nmcli dev wifi show-password
```

## Show all coonections whether currently active or not

```bash
# display connections that have been configured previously, whether currently active or not, both wired and wireless
nmcli c
```

## Low-level WiFi tools

```bash
# Monitor WiFi packets (requires aircrack-ng)
sudo apt install aircrack-ng -y
sudo airmon-ng start wlan0
sudo airodump-ng wlan0mon
sudo airmon-ng stop wlan0mon

# stop NetworkManager from interfering (airmon-ng will offer 'check kill')
sudo airmon-ng check kill

# start monitor mode (this typically creates wlp3s0mon)
sudo airmon-ng start wlp3s0

# ...do your passive captures (airodump-ng, wireshark, etc.)...

# stop monitor mode and restore NetworkManager
sudo airmon-ng stop wlp3s0mon
sudo systemctl restart NetworkManager

```

[Back to top](#wifi-commands)
