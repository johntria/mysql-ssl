#!/bin/bash

cd /var/lib/cert/
#Delete all old certs if exist
rm -rf /var/lib/cert/*

# Create CA certificate
openssl genrsa 2048 > ca-key.pem
openssl req -new -x509 -nodes -days 3600 \
        -key ca-key.pem -out ca.pem \
        -subj "/C=${COUNTRY}/ST=${STATE}/L=${LOCALITY}/O=${ORGANIZATION}/OU=${ORGANIZATIONAL_UNIT}/CN=${COMMON_NAME_CA}/emailAddress=${EMAIL_ADDRESS}"

# Create server certificate, remove passphrase, and sign it
# server-cert.pem = public key, server-key.pem = private key
openssl req -newkey rsa:2048 -days 3600 \
        -nodes -keyout server-key.pem -out server-req.pem \
        -subj "/C=${COUNTRY}/ST=${STATE}/L=${LOCALITY}/O=${ORGANIZATION}/OU=${ORGANIZATIONAL_UNIT}/CN=${COMMON_NAME_SERVER}/emailAddress=${EMAIL_ADDRESS}"
openssl rsa -in server-key.pem -out server-key.pem
openssl x509 -req -in server-req.pem -days 3600 \
        -CA ca.pem -CAkey ca-key.pem -set_serial 01 -out server-cert.pem

# Create client certificate, remove passphrase, and sign it
# client-cert.pem = public key, client-key.pem = private key
openssl req -newkey rsa:2048 -days 3600 \
        -nodes -keyout client-key.pem -out client-req.pem \
        -subj "/C=${COUNTRY}/ST=${STATE}/L=${LOCALITY}/O=${ORGANIZATION}/OU=${ORGANIZATIONAL_UNIT}/CN=${COMMON_NAME_CLIENT}/emailAddress=${EMAIL_ADDRESS}"
openssl rsa -in client-key.pem -out client-key.pem
openssl x509 -req -in client-req.pem -days 3600 \
        -CA ca.pem -CAkey ca-key.pem -set_serial 01 -out client-cert.pem

#Verfiy client and server certs with ca
openssl verify -CAfile ca.pem server-cert.pem client-cert.pem

echo -e "yes" | keytool -importcert -alias MySQLCACert.jks -file /var/lib/cert/ca.pem \
    -keystore /var/lib/cert/truststore.jks -storepass "$KEYSTORE_PASSWORD"

openssl pkcs12 -export -in /var/lib/cert/client-cert.pem -inkey /var/lib/cert/client-key.pem \
    -out /var/lib/cert/certificate.p12 -name "certificate" -password pass:"$KEYSTORE_PASSWORD"

echo -e "$KEYSTORE_PASSWORD" | keytool -importkeystore -srckeystore /var/lib/cert/certificate.p12 \
    -srcstoretype pkcs12 -destkeystore /var/lib/cert/client-cert.jks -storepass "$KEYSTORE_PASSWORD"