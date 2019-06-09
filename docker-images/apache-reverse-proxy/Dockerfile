FROM php:5.6-apache

LABEL authors = "Tiago Povoa, Christoph Rouff soit Rueff"

# We copy our tuned version of the apache2-foreground file
COPY apache2-foreground /usr/local/bin/

# Copying config-template.php
COPY templates /var/apache2/templates

COPY conf/ /etc/apache2

# enable module (activate)
RUN a2enmod proxy proxy_http 
# enable virtual host for a site 
RUN a2ensite 000-* 001-*
