#!/bin/sh

# Check Samba server availability
if smbclient -L "//localhost/cert_share/"  -U admin%1234; then
  echo "Samba server is healthy"
  exit 0
else
  echo "Samba server is not healthy"
  exit 1
fi