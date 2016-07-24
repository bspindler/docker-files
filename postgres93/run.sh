#!/bin/bash
# you can start via docker-compose up -d or... 

# run and expose 5432 port
# docker run --name postgres -e POSTGRES_PASSWORD=postgres -p 5432:5432 -d postgres:9.3
# 
# fire up a psql client - using docker host
# docker run -it --rm postgres:9.3 psql -h 192.168.99.100 -U postgres


# just run but don't expose port on host
# docker run --name postgres -e POSTGRES_PASSWORD=postgres -d postgres:9.3
# 
# fire up a psql client - using internal network link
# docker run -it --rm --link postgres:postgres postgres:9.3 psql -h postgres -U postgres

