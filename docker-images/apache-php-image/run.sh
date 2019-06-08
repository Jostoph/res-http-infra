# This script helps running the server
docker build -t res/apache_php .
docker run -p 9090:80 res/apache_php