
timeout="--connect-timeout 10"
enddate="-enddate 20230930164600Z" 

name="serverec"
key="$name.key.pem"
cert="$name.pem"

# subj="-subj /C=GB/O=Doc/CN=SERVER" 

CA="caEC256"
cafiles="-cert $CA.pem -keyfile $CA.key.pem "


md="-md sha384"
policy="-policy signing_policy"
caextensions="-extensions server"
config="-config ca.config"

openssl ca $config $policy $ext $md $cafiles -out $cert -in $name.csr $enddate $caextensions 

openssl x509  -in $name.pem  -noout -text

 
 



