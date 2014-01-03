#!/bin/sh

# git add .
# git commit -m "Deployment on $(hostname) at $(date '+%Y-%m-%d %H:%M:%S')" 2> /dev/null
git tag -a $(date '+%Y-%m-%d-%H-%M-%S') -m "Deployment at $(date '+%Y-%m-%d %H:%M:%S')"
