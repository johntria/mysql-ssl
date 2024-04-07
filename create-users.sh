#!/bin/bash
adduser --disabled-password "$SAMBA_USER"
(echo $SAMBA_PASSWORD; echo $SAMBA_PASSWORD) | smbpasswd -a $SAMBA_USER
smbd