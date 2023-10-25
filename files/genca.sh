#!/bin/bash  -x 
BASEDIR=$(dirname "$0")

CA="caEC256"
casubj=" -subj /C=GB/O=DOC/OU=CA/CN=SSCA256"
days="-days 600"
rm $CA.pem $CA.key.pem
out="-out $CA.pem"
outform="-outform PEM"
keyform="-keyform pem"
key="-key $CA.key.pem "

config="-config $BASEDIR/ca.config"
extensions="-extensions genCA"


openssl ecparam -name prime256v1 -genkey -noout -out $CA.key.pem
#generate the certificate
#openssl req -x509 -sha384  $key $keyform -nodes $casubj $out $outform $days 
openssl req -x509 -sha384  $key $keyform -nodes $casubj $out $outform $days $config $extensions
# print it
openssl x509 -in $CA.pem -text -noout|less

password=" -passin file:$BASEDIR/password.file -passout  file:$BASEDIR/password.file"

openssl pkcs12 -export -inkey $CA.key.pem -in $CA.pem -out $CA.p12 $password



