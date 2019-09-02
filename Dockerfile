FROM    debian:10-slim as build

# Install apache
RUN     apt-get update \
&&	apt-get -y install dumb-init apache2

# Add Fancy Index
ADD	https://github.com/Vestride/fancy-index/archive/master.tar.gz /usr/share/
RUN	tar xzf /usr/share/master.tar.gz -C /usr/share

# Configure apache
RUN	echo 'ServerSignature Off' >> /etc/apache2/apache2.conf \
&&	echo 'TraceEnable Off' >> /etc/apache2/apache2.conf \
&&	echo 'ServerTokens Prod' >> /etc/apache2/apache2.conf \
&&	echo 'ServerName docker-http' >> /etc/apache2/apache2.conf \
&&	echo 'Alias /fancy-index /usr/share/fancy-index-master' >> /etc/apache2/apache2.conf \
&&	echo '<Directory /var/www/html>' >> /etc/apache2/apache2.conf \
&&	cat /usr/share/fancy-index-master/.htaccess >> /etc/apache2/apache2.conf

# Add auth handler
COPY	docker-run.sh /

# Final image
FROM	scratch
COPY	--from=build / /

ENTRYPOINT ["/usr/bin/dumb-init", "--"]

EXPOSE  80

CMD	["/docker-run.sh"]
