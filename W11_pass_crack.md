```bash
# Switch cmd to ease of access 

c:
cd windows/system32
ren utilman.exe utilman.old
copy cmd.exe utilman.exe
exit
-
cd windows\system32
del utilman.exe
ren utilman.old utilman.exe

__________________________
c:
cd windows/system32
ren sethc.exe sethc.exe.bak
copy cmd.exe sethc.exe
exit
-
cd windows\system32
del sethc.exe
ren sethc.exe.bak sethc.exe

__________________________ re-assigning pass to existing acc
net user
-- net user <username> 
-- net user <username> /active:yes
net user <username> *
Enter new password twice to confirm and type "exit" and press enter

----------- creating new acc with pass
net user
net user <username> <pass>

__________________________
c:
cd windows/system32

net user temp <password> /add
net localgroup administrators temp /add

Log Out and Log In as the Temporary User
Settings > Accounts > Sign-in options > Password > Change 

net localgroup administrators temp /delete	-- remove admin rights
net user temp /delete	-- delete user account
```