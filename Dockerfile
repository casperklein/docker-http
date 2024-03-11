FROM	debian:12-slim as build

ARG	PACKAGES="apache2 dumb-init"

# Install packages
ARG	DEBIAN_FRONTEND=noninteractive
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

# Build final image
FROM	scratch

ARG	VERSION="unknown"

LABEL	org.opencontainers.image.description="Quick way to share files with a Fancy-Index-Listing via HTTP"
LABEL	org.opencontainers.image.source="https://github.com/casperklein/docker-http/"
LABEL	org.opencontainers.image.title="docker-http"
LABEL	org.opencontainers.image.version="$VERSION"

EXPOSE	80

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD	["/run.sh"]

COPY	--from=build / /
