#!/bin/bash

if [ ! -d "/html" ]; then
	echo -e "Error: No host directory mounted to /html\n" >&2
	exit 1
fi

echo -ne "HTTP-Auth:\t"

# check if $user/$pass is supplied
# shellcheck disable=SC2154
if [ -n "$user" ] && [ -n "$pass" ] || [ -n "$auth" ]; then
	# enable auth
	sed -i 's;<Directory /html>;<Directory /foo>;' /etc/apache2/conf-available/z-custom-config.conf
	sed -i 's;<Directory /marker>;<Directory /html>;' /etc/apache2/conf-available/z-custom-config.conf
	echo "enabled"

	# generate user/pass if $auth is supplied
	if [ -n "$auth" ]; then
		user=$(tr -dc A-Za-z0-9 < /dev/urandom | head -c 10)
		pass=$(tr -dc A-Za-z0-9 < /dev/urandom | head -c 10)
	fi

	echo -e "Username:\t$user"
	echo -e "Password:\t$pass"

	# generate .htdigest file
	DIGEST="$(printf "%s:%s:%s" "$user" "This is a private system. Do not attempt to login unless you are an authorized user." "$pass" | md5sum | awk '{print $1}')" &&
	printf "%s:%s:%s\n" "$user" "This is a private system. Do not attempt to login unless you are an authorized user." "$DIGEST" > /.htdigest || exit 1
else
	echo "disabled"
fi

echo

# Start apache2
apachectl start &&

# Show logs
tail -F /var/log/apache2/*
