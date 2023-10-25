#!/bin/bash  -x 
BASEDIR=$(dirname "$0")

timeout="--connect-timeout 10"
enddate="-enddate 20230930164600Z" 
enddate="-days 2"

name="serverec"
key="$name.key.pem"
cert="$name.pem"

# subj="-subj /C=GB/O=Doc/CN=SERVER" 

CA="caEC256"
cafiles="-cert $CA.pem -keyfile $CA.key.pem "

touch "./index.txt"
serial="-rand_serial"

md="-md sha384"
policy="-policy signing_policy"
caextensions="-extensions server"
config="-config $BASEDIR/ca.config"

#openssl ca $config $policy $ext $md $cafiles -out $cert -in $name.csr $enddate $caextensions  $serial
openssl ca $config  $cafiles   -revoke $cert  
# openssl x509  -in $name.pem  -noout -text

 
 



