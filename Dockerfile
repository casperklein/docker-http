FROM	debian:10-slim as build

ENV	PACKAGES="apache2 curl dumb-init"
ENV	PACKAGES_CLEAN="curl"

# Install packages
ENV	DEBIAN_FRONTEND=noninteractive
RUN	apt-get update \
&&	apt-get -y upgrade \
&&	apt-get -y --no-install-recommends install $PACKAGES \
&&	rm -rf /var/lib/apt/lists/*

# Copy root filesystem
COPY	rootfs /

# Configure apache
RUN	a2enconf z-custom-config.conf \
&&	a2enmod auth_digest

# Add/Configure Fancy Index
ADD	https://github.com/Vestride/fancy-index/archive/main.tar.gz /usr/share/
RUN	tar xzf /usr/share/main.tar.gz -C /usr/share \
&&	echo 'Alias /fancy-index /usr/share/fancy-index-main' >> /etc/apache2/apache2.conf \
&&	echo '<Directory /html>' >> /etc/apache2/apache2.conf \
&&	cat /usr/share/fancy-index-main/.htaccess >> /etc/apache2/apache2.conf \
&&	echo '</Directory>' >> /etc/apache2/apache2.conf

# Cleanup
RUN	apt-get -y purge $PACKAGES_CLEAN \
&&	apt-get -y autoremove

# Build final image
FROM	scratch

EXPOSE	80

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD	["/run.sh"]

COPY	--from=build / /
