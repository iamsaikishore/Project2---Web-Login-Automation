FROM ubuntu

MAINTAINER kichu kichu123@gmail.com

RUN apt-get update -y

RUN apt-get install apache2 -y

COPY index.html /var/www/html/

COPY css /var/www/html/css/

CMD ["/usr/sbin/apachectl", "-D", "FOREGROUND"]


