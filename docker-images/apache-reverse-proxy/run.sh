# Image with static content
# No port mapping, runs in background
# -d = mode daemon
docker build -t res/apache_php ../apache-php-image/
# This dummy container is launched just to show our configuration is working properly
docker run -d res/apache_php
docker run -d --name apache_static res/apache_php

# Image with the API animals
# No port mapping, runs in background
docker build -t res/express_animals ../express-image/
# This dummy container is launched just to show our configuration is working properly
docker run -d res/express_animals
docker run -d --name express_dynamic res/express_animals


# This will build and run the image of the reverse proxy
# -e allows to add an env variable, you'd have to change this IPs to correspond to your configuration
docker build -t res/apache_rp .
docker run -e STATIC_APP=172.17.0.3:80 -e DYNAMIC_APP=172.17.0.5:3000 --name apache_rp -p 8080:80 res/apache_rp