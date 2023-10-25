# Practical TLS using openssl
This document, along with the other files, give a practical guide to using TLS with OPENSSL.

It does the following 

-  creates a self signed certificate
- sets up a client/server operation, so you can see the handshake and the flows.
- sets up a certificate authority
- sets up a signed certificate
- sets up a client/server operation using the signed certificate.

It should provide all of the files you need.

You should repeat running the tests over a few days. The runs may not always work because one of the certificate expires after 1 day!  You'll need to fix it.  This will give you some experience  in debugging TLS problems.

# Environment
This has been tested on Ubuntu Linux 22.40, and should work on other environments where openssl is supported.

## Execution environment
I created and used a directory ~/tmp/tls.

I wexecuted the commands like 
```
sh    ~/git/TLSWorkshop/files/s_client.sh 

``` 
and it stored the certificates etc in the current directory (~tmp/tls).


## Create a self signed certificate
### genss.sh
Review the genss.sh script.  The key line is

    openssl req -x509 $config  $key $out $keyout  $subj $ext  $password

This creates a certificate of type RSA with keysize of 2048 bits.  key="-newkey rsa:2048 " 

Execute the shell script using 

    sh genss.sh 

Use the man openssl req command to display all of the parameters

This uses a configuration file genss.config. In the shell script it has 

    ext="-extensions ss_extensions"

the section  ss_extensions is used from the config file.

Browsers tend not to use self signed certificates because they are not trusted.

### genss.config
Configuration is stored in a file, for ease of reuse ( and reduced typing on the command line)

Someof of the key lines are

- keyUsage             = critical, keyEncipherment
- extendedKeyUsage      = critical, serverAuth

This says the certificate can be used for encrypting keys.  The server can the certificate, but a client cannot use it 

## Use the certificate as a server
### server.sh 
This script uses the openssl server function to run as a server.
Within the script are several parameters, which you may want to play with.  For example
```
    tls="-tls1_3  "
    tls=" "
    tls="-tls1_2 "
```

By moving the lines around, and moving the -tls1_3 to the bottom of the list, you will then that tls option.

Start the long running server by running sh server.sh

### s_client.sh
This uses the openssl function to run as a client.
Create a new window and run the client by using sh s_client.sh

### The output
```
Certificate chain
 0 s:C = GB, CN = ss
   i:C = GB, CN = ss
   a:PKEY: rsaEncryption, 2048 (bit); sigalg: RSA-SHA256
   v:NotBefore: Oct  2 17:27:59 2023 GMT; NotAfter: Nov  1 17:27:59 2023 GMT
```
This identifies the certificate and the issuer.  

-  As this is self signed, the issuer is the same as the subject.
-   You can see this is an RSA certificate with a 2048 bit  key size
-  You can see the validity dates of the certificate


The output has 

```
   ----BEGIN CERTIFICATE-----
   MIIDUTCCAjmgAwIBAgIUciyYlM3jexq9BrnHeXv4+U+/Fk0wDQYJKoZIhvcNAQEL
   ...
   t5oPT5a7i/0ytPWEK9bvYF4wx1rZ4r0Ms7vuLq0z7Hr7CZQ5JA==  
   -----END CERTIFICATE-----
```

```
   Server certificate
   subject=C = GB, CN = ss
   issuer=C = GB, CN = ss
```

This is the certificate the server sent down to the client

```
   No client certificate CA names sent
```
The server did not send a list of CA names to the client

```
   Client Certificate Types: RSA sign, DSA sign, ECDSA sign

```

The server supports certificate in the following types RSA,DSA, ECDSA

```
   New, TLSv1.2, Cipher is ECDHE-RSA-AES256-GCM-SHA384
   Server public key is 2048 bit
```

The cipher spec ECDHE-RSA-AES256-GCM-SHA384 will be used.

```
   Verify return code: 18 (self-signed certificate)
```

Gives information about the certificate.


## Output on the server
The server reports
```
   depth=0 C = GB, CN = ss
   verify error:num=18:self-signed certificate
   verify return:1
   depth=0 C = GB, CN = ss
   verify error:num=26:unsupported certificate purpose
   verify return:1

```

The 

verify error:num=26:unsupported certificate purpose

is because the certifcate needs Extended Key Usage (EKU) with clientAuth. EKU of clientAuth needs Key Usage (KU) of Digitalsignature.  See https://superuser.com/questions/738612/openssl-ca-keyusage-extension

Change the certificate and validate it.

## Create a Certificate Authority
The important part of the script is

### The genca.sh script 
```
   openssl ecparam -name prime256v1 -genkey -noout -out $CA.key.pem
   openssl req -x509 -sha384  $key $keyform -nodes $casubj $out $outform $days
   # print it
   openssl x509 -in $CA.pem -text -noout|less

```

This 

- generates a private key with EC curve with the type prime26v1
- creates a (self signed) certificate 
- create the files with the file name caEC256
- The CA expires in 6 days  (see the genca.sh script)

## Generate the signed server certificate

Look at the  genServerEC.sh file.

Execute the script.  Check the information

- what type is it?
- what is the subject?
- what is the expiry dat
- e range?
- does it have an issuer? if not why not?
- what sort of public key is it, and what key size?

###  Send the .csr file to the CA machine
In this workshop the CA machine is where you are running, so you do not need to do this

### Sign the certificate
Review signServeEC.sh  .
Review the ca.config file.  


- Because this is a ca request it will look for the "ca" section.
- The script says caextensions="-extensions server" so it will look for a section called server.

The ca section says

```
[ ca ]
default_ca    = CA_default      # The default ca section
```
Which says go and use the section called CA_default.

The [ CA_default ] section has defaults.
References to basedir is where openssl CA keeps its information.  You will find files like 02A9.pem
 which is the certificate for serial number 02A9.


Execute the script.

As a Certificate Authority person, you need to check the information in the request.
If you are happy with the information reply Y to the prompt. 
You should not have replied Y...  edit the script and fix the problem.

Rerun the script

Check the information in the certificate, such as issuer, subject, what it can be used for,

### Send the signed certificate back to the requestor
As you are requestor and CA on the same machine, you do not need to do this.




## Generate the signed client certificate
Look at the genClientec384.sh file.

The important parts are
```
   openssl ecparam -name  secp384r1 -genkey -noout -out $name.key.pem
   openssl req $config -new -key $key -out $name.csr -outform PEM -$subj $passin $passout
   openssl ca $caconfig $policy $ext $md $cafiles -out $cert -in $name.csr $enddate $caextensions 

   openssl x509 -in $name.pem -text -noout 
```

This 

- generates a private key - elliptical with name secp384r1
- creates a request to send to the CA.
- the CA signs it
- the certificate is displayed.

Check the information in the certificate, for example the issuer, the validity dates, and the subject.

The command openssl pkcs12... is used to create a .p12 file which can be imported and used by a web browser.

## Run the signed certificate scenario

Stop any other server you have running.

Review and run sh ca_server.sh 

Review and run the client sh ca_s_client.sh in a different window.  

In the output it has

```
   depth=1 C = GB, O = DOC, OU = CA, CN = SSCA256
   verify error:num=19:self-signed certificate in certificate chain
   verify return:1
```
This is because the top level of the chain is self signed (as expected)



Review the certificate chain.

Ignore the certificate

```
Acceptable client certificate CA names
C = GB, O = DOC, OU = CA, CN = SSCA256
Client Certificate Types: RSA sign, DSA sign, ECDSA sign

```
The server has sent down the list of the CA certificates in its trust store.
The server will accept certificates signed by the CA, and of type RSA, EC, ECDSA

## Run a curl request into the server.

```
curl --cacert ./caEC256.pem --cert clientEC384.pem --key clientEC384.key.pem -v   https://localhost:4433
```


# Extending the server and client certificate
You can add extensions to the certificate requests, for example specify which KU and  EKU are required, and what IP address the server will use.

For the "req" to create a certificate request, you can specify a configuration file which has sections.

By default the "req" command will look for a section called "req".  You can specify additonak  sections to use.

Edit the client.config file and add
```
[ req ]
default_bits        = 2048 
req_extensions          = v3_req


[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment

```

Edit the server script and specify
config="-config client.config"

Run the script, and check the output has the specified attributes ( eg CA:false)


Edit the script to use
extensions="-extensions server"
  
Add a section to the client.configu file

```
[ server ]
keyUsage               = digitalSignature, keyAgreement, digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName         = DNS:localhost, IP:222.0.0.1
extendedKeyUsage       = serverAuth
subjectKeyIdentifier   = hash
nsComment  = "server"


```


## OCSP
Change the client config file to have
```
[ server ]
keyUsage               = digitalSignature, keyAgreement, digitalSignature, nonRepudiation, keyEnciph
erment, dataEncipherment
subjectAltName         = DNS:localhost, IP:222.0.0.1

extendedKeyUsage       = serverAuth, OCSPSigning 
q
subjectKeyIdentifier   = hash
nsComment  = "server"

authorityInfoAccess = OCSP;URI:http://localhost:8080/

```

Regenerate the server certificate.

### Creating the OCSP server

In order to host an OCSP server, an OCSP signing certificate has to be generated. 

Review and run genOCSP.sh 


#### Start OCSP Server. 
Switch to a new terminal and run,

sh runOCSP.sh


#### Verify Certificate Revocation. 
Switch to a new terminal and run
 
```
sh checkOCSP.sh
```

This will show that the certificate status is good.
```
serverec.pem: good
	This Update: Oct 24 16:55:02 2023 GMT

```

## Revoke a certificate

### Revoke the certificate
If you want to revoke the certificate run following command

```
sh revokeServerEC.sh
```

It returns something like
```
Revoking Certificate 24D14101D144B0AC65EDDB089F23AAEAC3B8C036.
Data Base Updated

```

### Restart the OCSP server.

Cancel the  OCSP server and restart it

### Check the certificate again

```
sh checkOCSP.sh
```

This will show that the certificate status is revoked.
```
-----END CERTIFICATE-----
serverec.pem: revoked
	This Update: Oct 24 17:04:27 2023 GMT
	Revocation Time: Oct 24 17:00:28 2023 GMT


```

#Useful document

[This](https://github.com/xperseguers/ocsp-responder/blob/master/Documentation/CertificateAuthority.md ) is a good document.