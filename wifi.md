```bash
# show active wifi
nmcli c show --active		

# show all connected wifis
nmcli c				

# show wifi password of wifi
sudo nmcli -s -g 802-11-WIRELESS-SECURITY.PSK connection show "VC"	
```