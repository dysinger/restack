#!/usr/bin/env bash
for tick in $(seq 0 3); do
    sleep 1
    echo "$(curl -fsSL http://localhost:8080)"
done
