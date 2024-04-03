#!/bin/bash
for i in $(seq 1 "${TOTAL_SAMBA_USERS}")
do
eval user=\$SAMBA_USER_$i
eval password=\$SAMBA_PASSWORD_$i
echo "Username: $user"
echo "Password: $password"
adduser --disabled-password "$user"
(echo $password; echo $password) | smbpasswd -a $user
done
smbd