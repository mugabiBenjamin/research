## Show available networks

```bash
# show only WiFi networks that are currently broadcasting in range
nmcli dev wifi list
```

```bash
# show active wifi
nmcli connection show --active

# alternatively
nmcli c show --active
```

```bash
# show wifi password of wifi
sudo nmcli -s -g 802-11-WIRELESS-SECURITY.PSK connection show "SSID"
```

## Display QR code for active network

```bash
# display password and qrcode of currently connected network
nmcli dev wifi show-password
```

## Low-level WiFi tools

```bash
# display connections that have been configured previously, whethher currently active or not, both wired and wireless
nmcli c
```

```bash
# Monitor WiFi packets (requires aircrack-ng)
sudo apt install aircrack-ng -y
sudo airmon-ng start wlan0
sudo airodump-ng wlan0mon
sudo airmon-ng stop wlan0mon
```
