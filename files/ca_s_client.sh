
#tls="-tls1_3 -no_tls1_2 -no_tls1_1"
#tls="-tls1_2 -no_tls1_3 -no_tls1_1"
#tls="-tls1_2 "

name="clientEC384"
cert=" -cert ./$name.pem -key ./$name.key.pem"

cipher=""
port="4433"
CA="-CAfile  ./caEC256.pem"
# cafiles="-cert $CA.pem -keyfile $CA.key.pem "

tls=""
pass="-pass file:password.file" 
debug="-debug"
debug=""
msg="-msg"
msg=""

showcerts="-showcerts"
showcerts=""

quiet="-quiet"
quiet=""
verify="-verify_ip 127.0.0.1 -x509_strict  -issuer_checks"
verify="-verify_depth  0" 
openssl s_client $quiet $pass $tls $verify  $showcerts $cipher $cert  $ca $msg $debug 127.0.0.1:$port  
 

