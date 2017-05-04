#!/bin/bash

docker-compose stop -t0
docker-compose rm -vf
docker rmi dockernginxproxy_nginx
docker-compose up -d