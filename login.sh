#!/bin/bash

AUTH=$(cat <<"EOF"
AuthType Digest
AuthName "This is a private system. Do not attempt to login unless you are an authorized user."
AuthDigestProvider file
AuthUserFile /.htdigest
Require valid-user
EOF
)

# check if user/pass is supplied
echo -ne "HTTP-Auth:\t"
if [ -n "$user" ] && [ -n "$pass" ]; then
	# enable auth_digest module and generate .htdigest file
	echo "enabled"
	echo -e "Username:\t$user"
	echo -e "Password:\t$pass"
	a2enmod auth_digest > /dev/null &&
	echo "$AUTH" >> /etc/apache2/apache2.conf &&
	DIGEST="$(printf "%s:%s:%s" "$user" "This is a private system. Do not attempt to login unless you are an authorized user." "$pass" | md5sum | awk '{print $1}')" &&
	printf "%s:%s:%s\n" "$user" "This is a private system. Do not attempt to login unless you are an authorized user." "$DIGEST" > /.htdigest || exit 1
else
	echo "disabled"
fi

echo '</Directory>' >> /etc/apache2/apache2.conf

echo
