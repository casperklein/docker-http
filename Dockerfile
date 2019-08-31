FROM    debian:10-slim as build

# Install apache2
RUN     apt-get update \
&&	apt-get -y install apache2

# Add Fancy Index
ADD	https://github.com/Vestride/fancy-index/archive/master.tar.gz /usr/share/
RUN	tar xzf /usr/share/master.tar.gz -C /usr/share

# Configure apache2
RUN	echo 'ServerName docker-http' >> /etc/apache2/apache2.conf \
&&	echo 'Alias /fancy-index /usr/share/fancy-index-master' >> /etc/apache2/apache2.conf \
&&	echo '<Directory /var/www/html>' >> /etc/apache2/apache2.conf \
&&	cat /usr/share/fancy-index-master/.htaccess >> /etc/apache2/apache2.conf

# Add auth handler
COPY	login.sh /

# Final image
FROM	scratch
COPY	--from=build / /

EXPOSE  80

CMD     /login.sh \
&&	apachectl start \
&&	tail -F /var/log/apache2/*
