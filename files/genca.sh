CA="caEC256"
casubj=" -subj /C=GB/O=DOC/OU=CA/CN=SSCA256"
days="-days 600"
rm $CA.pem $CA.key.pem
out="-out $CA.pem"
outform="-outform PEM"
keyform="-keyform pem"
key="-key $CA.key.pem "

openssl ecparam -name prime256v1 -genkey -noout -out $CA.key.pem
#generate the certificate
openssl req -x509 -sha384  $key $keyform -nodes $casubj $out $outform $days
# print it
openssl x509 -in $CA.pem -text -noout|less


