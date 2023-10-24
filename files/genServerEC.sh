
timeout="--connect-timeout 10"
enddate="-enddate 20291026164600Z" 

ext="-extensions end_user"

name="serverec"
key="$name.key.pem"
cert="$name.pem"

rm $name.key.pem
rm $name.csr
rm $name.pem


subj="-subj /C=GB/O=Doc/CN=EC-SERVER" 

passin="-passin file:password.file"
passout="-passout file:password.file"

#md="-md sha384"

#policy="-policy signing_policy"

#caconfig="-config ca.config"
#caextensions="-extensions server"
extensions=""

extensions="-reqexts  server"

config="-config client.config"
#config=""


openssl ecparam -name  prime256v1 -genkey -noout -out $name.key.pem 
openssl req $config -new -key $key -out $name.csr -outform PEM -$subj $passin $passout $extensions
openssl req -in $name.csr   -text -noout|less

