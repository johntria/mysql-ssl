#!/bin/bash
cd /usr/local/bin
# Create clean environment
mkdir -p newcerts
cd newcerts

# Create CA certificate
openssl genrsa 2048 > ca-key.pem
openssl req -new -x509 -nodes -days 3600 \
        -key ca-key.pem -out ca.pem \
        -subj "/C=GR/ST=Peloponnese/L=Kalamata/O=d-roa/OU=IT/CN=fakeca/emailAddress=john.3fyl@gmail.com"

# Create server certificate, remove passphrase, and sign it
# server-cert.pem = public key, server-key.pem = private key
openssl req -newkey rsa:2048 -days 3600 \
        -nodes -keyout server-key.pem -out server-req.pem \
        -subj "/C=GR/ST=Peloponnese/L=Kalamata/O=d-roa/OU=IT/CN=fakeserver/emailAddress=john.3fyl@gmail.com"
openssl rsa -in server-key.pem -out server-key.pem
openssl x509 -req -in server-req.pem -days 3600 \
        -CA ca.pem -CAkey ca-key.pem -set_serial 01 -out server-cert.pem

# Create client certificate, remove passphrase, and sign it
# client-cert.pem = public key, client-key.pem = private key
openssl req -newkey rsa:2048 -days 3600 \
        -nodes -keyout client-key.pem -out client-req.pem \
        -subj "/C=GR/ST=Peloponnese/L=Kalamata/O=d-roa/OU=IT/CN=fakeclient/emailAddress=john.3fyl@gmail.com"
openssl rsa -in client-key.pem -out client-key.pem
openssl x509 -req -in client-req.pem -days 3600 \
        -CA ca.pem -CAkey ca-key.pem -set_serial 01 -out client-cert.pem


openssl verify -CAfile ca.pem server-cert.pem
openssl verify -CAfile ca.pem client-cert.pem

chown -R 1000:1000 /usr/local/bin/
chmod -R 700 /usr/local/bin/