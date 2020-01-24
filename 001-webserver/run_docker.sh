#!/usr/bin/env bash
docker run --init --name 001-webserver --publish 8080:8080 restack/001-webserver
