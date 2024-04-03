#!/bin/sh

# Define your Samba server IP and share name
SAMBA_SERVER="localhost"
# Check Samba server availability
if smbclient -L "//10.5.0.5/cert_share/"  -U admin%1234; then
  echo "Samba server is healthy"
  exit 0
else
  echo "Samba server is not healthy"
  exit 1
fi