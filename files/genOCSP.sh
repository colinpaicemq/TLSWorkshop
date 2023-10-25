#!/bin/bash  -x 
BASEDIR=$(dirname "$0")

password=" -passin file:$BASEDIR/password.file -passout  file:$BASEDIR/password.file"


timeout="--connect-timeout 10"
enddate="-enddate 20240930164600Z" 

ext="-extensions end_user"

name="OCSP"

key="$name.key.pem"
cert="$name.pem"

rm $key
rm $name.csr
rm $cert


subj="-subj /C=GB/O=DOC/CN=OCSP" 



#md="-md sha384"

#policy="-policy signing_policy"

caconfig="-config $BASEDIR/ca.config"

extensions=""

extensions="-reqexts  server"

config="-config $BASEDIR/client.config"
policy=""
ext=""
md="-md sha384"
CA="caEC256"

cafiles="-cert $CA.pem -keyfile $CA.key.pem "
#caextensions="-extensions OCSP"
#extensions="-reqexts  server"

#config=""

openssl ecparam -name  secp384r1 -genkey -noout -out $key
openssl req -new -nodes -out $name.csr -key $key  $subj

openssl ca $caconfig $policy $ext $md $cafiles -out $cert  -in $name.csr $enddate $caextensions 
# openssl ca -keyfile rootCA.key -cert rootCA.crt -in ocspSigning.csr -out ocspSigning.crt -config validation.confopenssl ecparam -name  prime256v1 -genkey -noout -out $name.key.pem 
#openssl req $config -new -key $key -out $name.csr -outform PEM -$subj $password $extensions
#openssl req -in $name.csr   -text -noout|less

