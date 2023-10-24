ca="caEC256"
cert="-cert clientEC384.pem"
cert="-cert docecserver.pem"
url="-url http://127.0.0.1:9999"
url="" 
openssl ocsp -CAfile $ca.pem  -issuer $ca.pem $cert $url  -resp_text -noverify
