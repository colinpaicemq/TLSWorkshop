
tls="-tls1_3 -no_tls1_2 -no_tls1_1"
tls="-tls1_2 -no_tls1_3 -no_tls1_1"
tls="-tls1_2 "
name="ss"
cert=" -cert ./$name.pem -key ./$name.key.pem"
 

cipher=""
port="4433"
ca="-CAfile ./doczosca.pem "
ca="-CAfile ./zpdt.ca.pem "
ca=""
tls=""
pass="-pass file:password.file" 
debug="-debug"
debug=""
msg="-msg"
msg=""
showcerts="-showcerts"
showcerts=""

openssl s_client $pass $tls -showcerts $cipher $cert  $ca $msg $debug 127.0.0.1:$port  
 

