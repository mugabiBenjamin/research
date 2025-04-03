# W11 bypass

```bash
# How to bypass administrative privileges in w11 

• Press Windows key + S to open the search box.
• Type "Command Prompt" and choose it from the results list. Make sure to run it as an administrator.
• Type net user. 
• Type net user administrator * and hit Enter. Type in a strong password and then confirm it.
• To set a new password for a specific user account, type net user a-user (strong_password) and hit Enter, replacing "a-user" with the username of the desired account that needs a new password.
• If you want to grant administrative privileges to a specific user, use: net localgroup administrators a-user /add.
• To remove administrative privileges from the user, use: net localgroup administrators a-user /delete.
• To disable the default administrator account, type net user administrator /active:no and hit Enter.
• To re-enable the default administrator account, use net user administrator /active:yes. (strong_password)" and hit enter.
```
