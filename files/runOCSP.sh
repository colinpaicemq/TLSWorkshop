#!/bin/bash  -x 
BASEDIR=$(dirname "$0")


index="-index ./index.txt"
port="-port 9999"
rsigner="-rsigner OCSP.pem"
rkey="-rkey OCSP.key.pem" 
CA="-CA caEC256.pem"
out="-out log.txt"
out="" 

openssl ocsp $index $port $rsigner $rkey $CA -text $out 
