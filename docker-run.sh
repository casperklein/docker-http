#!/bin/bash

AUTH=$(cat <<"EOF"
AuthType Digest
AuthName "This is a private system. Do not attempt to login unless you are an authorized user."
AuthDigestProvider file
AuthUserFile /.htdigest
Require valid-user
EOF
)

# check if $user/$pass is supplied
echo -ne "HTTP-Auth:\t"
if [ -n "$user" ] && [ -n "$pass" ] || [ -n "$auth" ]; then
	echo "enabled"

	# generate user/pass if $auth is supplied
	if [ -n "$auth" ]; then
		user=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 10)
		pass=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 10)
	fi

	echo -e "Username:\t$user"
	echo -e "Password:\t$pass"

	# enable auth_digest module and generate .htdigest file
	a2enmod auth_digest > /dev/null &&
	echo "$AUTH" >> /etc/apache2/apache2.conf &&
	DIGEST="$(printf "%s:%s:%s" "$user" "This is a private system. Do not attempt to login unless you are an authorized user." "$pass" | md5sum | awk '{print $1}')" &&
	printf "%s:%s:%s\n" "$user" "This is a private system. Do not attempt to login unless you are an authorized user." "$DIGEST" > /.htdigest || exit 1
else
	echo "disabled"
fi

echo '</Directory>' >> /etc/apache2/apache2.conf

# Runnning behind a reverse proxy? Log the correct remote IP address.
if [ -n "$proxy" ]; then
	echo 'LogFormat "%t %{X-Forwarded-For}i %u \"%r\" %>s %O \"%{Referer}i\" \"%{User-Agent}i\"" combined' >> /etc/apache2/apache2.conf
fi

echo

# Start apache2
apachectl start &&

# Show logs
tail -F /var/log/apache2/*
