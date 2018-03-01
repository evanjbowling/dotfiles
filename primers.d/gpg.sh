#!/usr/bin/env bash
# Other references:
#  * https://davesteele.github.io/gpg/2014/09/20/anatomy-of-a-gpg-key/
#  * https://wiki.debian.org/Subkeys
# 
# Flag	gpg character	Description
# 0x01	“C”	Key Certification
# 0x02	“S”	Sign Data
# 0x04	“E”	Encrypt Communications
# 0x08	“E”	Encrypt Storage
# 0x10	 	Split key
# 0x20	“A”	Authentication
# 0x80	 	Held by more than one person

# create a new key
gpg --gen-key

# confirm key passphrase
echo "1234" | gpg -o /dev/null --local-user <KEYID> -as - && echo

# list public keys
gpg --list-keys

# list fingerprint
gpg --fingerprint "<REAL NAME>"

# list private keys
gpg --list-secret-keys
# sec#? ALGBITS YYYY-MM-DD [FLAG] [expires: YYYY-MM-DD]
#       <FINGERPRINT>
# uid           [<TRUST-STATUS>]   
# sub   ALGBITS YYYY-MM-DD [FLAG]

# list private keys with key ID
gpg --list-secret-keys --keyid-format LONG
# sec#? ALGBITS/KEYID YYYY-MM-DD [FLAG] [expires: YYYY-MM-DD]
#       <FINGERPRINT>
# uid           [<TRUST-STATUS>]   
# sub   ALGBITS/KEYID YYYY-MM-DD [FLAG]

# list keygrips
gpg --list-key --with-keygrip <KEYID>


