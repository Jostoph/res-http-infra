# kill and remove previous dockers
docker kill apache_static
docker rm apache_static
docker kill express_dynamic
docker rm express_dynamic
docker kill apache_rp
docker rm apache_rp

# Image with static content
# No port mapping, runs in background
# -d = mode daemon
docker build -t res/apache_php ../apache-php-image/
docker run -d --name apache_static res/apache_php

# Image with the API animals
# No port mapping, runs in background
docker build -t res/express_animals ../express-image/
docker run -d --name express_dynamic res/express_animals

# Get the docker IDs
static_app=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' apache_static)
echo "static_app : $static_app"
express_app=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' express_dynamic)
echo "express_app : $express_app"

# This will build and run the image of the reverse proxy
# -e allows to add an env variable, you'd have to change this IPs to correspond to your configuration
docker build -t res/apache_rp .
docker run -e STATIC_APP=$static_app:80 -e DYNAMIC_APP=$express_app:3000 --name apache_rp -p 8080:80 res/apache_rp
