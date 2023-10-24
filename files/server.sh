
#tls="-tls1_3 -no_tls1_2 -no_tls1_1 -no_ssl3 "
#tls="-tls1_2 -no_tls1_3 -no_tls1_1"
#tls="-tls1_2 "

tls="-tls1_3  "
tls=" "
tls="-tls1_2 "
name="ss"

cert=" -cert ./$name.pem -certform pem -key $name.key.pem -keyform pem" 

CA=""
cipher=""

port="-port 4433 "

# strict="-x509_strict -strict"
debug="-trace -security_debug_verbose"
debug="-trace "
debug=" "

msg="-msg"
msg=""
verify="-verify 0"
pass="-pass file:password.file" 


openssl s_server $port $tls  $cert $cipher $verify  $CA $debug $strict $pass -www  

