# Image with static content
# No port mapping, runs in background
docker build -t res/apache_php ../apache-php-image/
docker run -d --name apache_static res/apache_php

# Image with the API animals
# No port mapping, runs in background
docker build -t res/express_animals ../express-image/
docker run -d --name express_dynamic res/express_animals


# This will build and run the image of the reverse proxy
docker build -t res/apache_rp .
docker run -p 8080:80 res/apache_rp