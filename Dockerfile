FROM    debian:10-slim

RUN     apt-get update && apt-get install -y apache2

EXPOSE  80

CMD     apachectl start; tail -F /var/log/apache2/*
