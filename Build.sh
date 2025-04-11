#!/bin/sh

sudo docker-compose build --no-cache && \
    sudo docker-compose up --build -d