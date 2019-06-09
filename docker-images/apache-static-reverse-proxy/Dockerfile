FROM php:7.2-apache

LABEL authors = "Tiago Povoa, Christoph Rouff soit Rueff"

COPY conf/ /etc/apache2

# enable module (activate)
RUN a2enmod proxy proxy_http 
# enable virtual host for a site 
RUN a2ensite 000-* 001-*