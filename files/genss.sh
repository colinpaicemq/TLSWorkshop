#!/bin/bash  -x 
BASEDIR=$(dirname "$0")

name="ss"
rm $name.*


#create it
# openssl req -x509  -sha256 -utf8 -days 365 -nodes      !outform pem -subj 
key="-newkey rsa:2048 "
config="-config $BASEDIR/genss.config"

subj="-subj "/C=GB/O=SS/CN="$name"  

out="-out $name.pem "
keyout="-keyout $name.key.pem "
ext="-extensions ss_extensions"
password=" -passin file:$BASEDIR/password.file -passout  file:$BASEDIR/password.file"

openssl req -x509 $config  $key $out $keyout  $subj $ext  $password

echo "==============-purpose================"

openssl x509 -purpose -in $name.pem -inform PEM -nocert
echo "==============SAN================"
openssl x509  -in $name.pem  -noout -ext subjectAltName
echo "==============KEYUSAGE================"
openssl x509  -in $name.pem  -noout -ext keyUsage
echo "==============EKU================"
openssl x509  -in $name.pem  -noout -ext extendedKeyUsage 
 
echo "==============GREP Sig================" 
openssl x509  -in $name.pem  -noout -text |grep Sig 

echo "=============Subject ===================+++++++++"
openssl x509  -in $name.pem  -noout -text  |grep Subject:
openssl x509  -in $name.pem  -noout -text |grep Issuer: 

#rm ssks.p12  
openssl pkcs12 -export -in $name.pem -inkey $name.key.pem   -out $name.p12  -name "$name.xx" $password 

#openssl pkcs12 -export -inkey $name.key.pem  -in $name.pem  -out $name.p12 -CAfile cacert.pem -chain -name $name  -passout  file:password.file  -passin  file:password.file



# keyUsage               = cRLSigndigitalSignature, nonRepudiation, keyEncipherment, dataEncipherment, keyAgreement
# extendedKeyUsage      =  serverAuth,clientAuth







