#!/bin/bash  -x 
BASEDIR=$(dirname "$0")

ca="caEC256"
cert="-cert clientEC384.pem"
cert="-cert serverec.pem"
url="-url http://127.0.0.1:9999"

# openssl ocsp -issuer caEC256.pem  -cert serverec.pem   -url http://127.0.0.1:9999 -resp_text

openssl ocsp -CAfile $ca.pem  -issuer $ca.pem $cert $url  -resp_text -noverify
