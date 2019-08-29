FROM    debian:10-slim

RUN     apt-get update && apt-get -y install apache2

# Add Fancy Index
ADD	https://github.com/Vestride/fancy-index/archive/master.tar.gz /usr/share/
RUN	tar xzf /usr/share/master.tar.gz -C /usr/share \
&&	echo 'ServerName docker-http' >> /etc/apache2/apache2.conf \
&&	echo 'Alias /fancy-index /usr/share/fancy-index-master' >> /etc/apache2/apache2.conf \
&&	echo '<Directory /var/www/html>' >> /etc/apache2/apache2.conf \
&&	cat /usr/share/fancy-index-master/.htaccess >> /etc/apache2/apache2.conf \
&&	echo '</Directory>' >> /etc/apache2/apache2.conf

EXPOSE  80

CMD     apachectl start; tail -F /var/log/apache2/*
