#!/bin/bash  -x 
BASEDIR=$(dirname "$0")

#tls="-tls1_3 -no_tls1_2 -no_tls1_1 -no_ssl3 "
#tls="-tls1_2 -no_tls1_3 -no_tls1_1"
#tls="-tls1_2 "

tls="-tls1_3  "
tls=" "
tls="-tls1_2 "
name="docecserver"
name="serverec"
cert=" -cert ./$name.pem -certform pem -key $name.key.pem -keyform pem" 

CA="-CAfile  ./caEC256.pem"


#cafiles="-cert $CA.pem -keyfile $CA.key.pem "
#cafiles="-cert $CA.pem "

cipher=""

port="-port 4433 "

# strict="-x509_strict -strict"
debug="-trace -security_debug_verbose"
debug="-trace "
debug=" "
#debug=""
msg="-msg"
msg=""
verify="-verify 2"
pass="-pass file:$BASEDIR/password.file "  
OCSP="-status_verbose" 

#  ca="-CAfile ./zpdt.ca.pem "
openssl s_server $port $tls  $cert $cipher $verify  $CA $debug $strict $OCSP $pass -www  

