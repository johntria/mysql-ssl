#!/bin/bash
# Connect to MySQL and execute set variables
mysql -u"root" -p"$MYSQL_ROOT_PASSWORD"  << EOF
    SET PERSIST ssl_ca = "/var/lib/cert/ca.pem";
    SET PERSIST ssl_cert = "/var/lib/cert/server-cert.pem";
    SET PERSIST ssl_key = "/var/lib/cert/server-key.pem";
    SET PERSIST require_secure_transport=ON;
    ALTER INSTANCE RELOAD TLS;
EOF