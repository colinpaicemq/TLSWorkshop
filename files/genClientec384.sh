
timeout="--connect-timeout 10"
enddate="-enddate 20240130164600Z" 

ext="-extensions end_user"

name="clientEC384"
key="$name.key.pem"
cert="$name.pem"
# p12="$name.p12"
subj="-subj /C=GB/O=Doc/CN=Client-"$name 
CA="caEC256"

cafiles="-cert $CA.pem -keyfile $CA.key.pem "

rm $name.key.pem
rm $name.csr
rm $name.pem
passin="-passin file:password.file"
passout="-passout file:password.file"
md="-md sha384"
policy="-policy signing_policy"
caconfig="-config ca.config"
caextensions="-extensions client"
config="-config client.config"
config=""


openssl ecparam -name  secp384r1 -genkey -noout -out $name.key.pem 
openssl req $config -new -key $key -out $name.csr -outform PEM -$subj $passin $passout
openssl ca $caconfig $policy $ext $md $cafiles -out $cert -in $name.csr $enddate $caextensions 

openssl x509 -in $name.pem -text -noout

openssl pkcs12 -export -inkey $name.key.pem -in $name.pem -out $name.p12 -CAfile $CA.pem -chain -name $name -passout file:password.file -passin file:password.file

#openssl ecparam -name  secp256r1  -genkey -noout -out $name.key.pem 
#openssl req -config eccert.config -new -key $name.key.pem -out $name.csr -outform PEM -subj "/C=GB/O=cpwebuser/CN="$name   -passin file:password.file -passout file:password.file
#openssl ca -config openssl-ca-user.cnf -policy signing_policy $ext -md sha384 -cert $CA.pem    -keyfile $CA.key.pem -out $name.pem -in $name.csr $enddate -extensions clientServer
# openssl ca -config openssl-ca-user.cnf -policy signing_policy     -md sha256 -cert cacert.pem -keyfile cacert.key.pem  -out $name.pem  -extensions signing_mqweb -infiles $name.csr
#openssl x509 -in $name.pem -text -noout|less

 
 



