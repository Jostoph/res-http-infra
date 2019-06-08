# This script helps running the server

docker build -t res/express_animals .
docker run -p 9091:3000 res/express_animals
# docker run -it res/express_animals /bin/bash
