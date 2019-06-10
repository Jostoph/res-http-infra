#!/bin/bash

# kill all
docker kill $(docker ps -qa)
docker rm $(docker ps -qa)

echo "starting demo !"

docker-compose up -d --build

# adding some containers

docker-compose scale static-http=8
docker-compose scale express-dynamic=4
