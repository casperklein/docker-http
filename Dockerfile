FROM    debian:10-slim as build

ENV	USER="casperklein"
ENV	NAME="http"
ENV	VERSION="latest"

ENV	PACKAGES="apache2 curl"
ENV	PACKAGES_CLEAN="curl"

# Install packages
RUN     apt-get update \
&&	apt-get -y --no-install-recommends install $PACKAGES

# Copy root filesystem
COPY	rootfs /

# Configure apache
RUN	a2enconf z-custom-config.conf \
&&	a2enmod auth_digest

# Add/Configure Fancy Index
ADD	https://github.com/Vestride/fancy-index/archive/master.tar.gz /usr/share/
RUN	tar xzf /usr/share/master.tar.gz -C /usr/share \
&&	echo 'Alias /fancy-index /usr/share/fancy-index-master' >> /etc/apache2/apache2.conf \
&&	echo '<Directory /html>' >> /etc/apache2/apache2.conf \
&&	cat /usr/share/fancy-index-master/.htaccess >> /etc/apache2/apache2.conf \
&&	echo '</Directory>' >> /etc/apache2/apache2.conf

# Cleanup
RUN     apt-get -y purge $PACKAGES_CLEAN \
&&      apt -y autoremove

# Build final image
RUN	apt-get -y install dumb-init \
&&	rm -rf /var/lib/apt/lists/*
FROM	scratch
COPY	--from=build / /
ENTRYPOINT ["/usr/bin/dumb-init", "--"]

EXPOSE  80

#HEALTHCHECK --retries=1 CMD curl -f -A 'Docker: Health-Check' http://127.0.0.1/ || exit 1

CMD	["/run.sh"]
