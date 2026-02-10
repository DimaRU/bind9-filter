#!/bin/bash
docker build --build-arg bind_ver=$1 -t bind9filter:latest .
docker create --name bind9filter bind9filter:latest
docker cp bind9filter:/build/filter/filter-a-cond.so .
docker cp bind9filter:/build/filter/filter-aaaa-cond.so .
docker rm bind9filter
docker rmi bind9filter:latest
