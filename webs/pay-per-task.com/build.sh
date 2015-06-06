#!/bin/bash

# TODO: Haproxy -> API & this.
# TODO: Trigger Dockerhub build just for this repo.
# - docker login -e $DOCKER_EMAIL -u $DOCKER_USER -p $DOCKER_PASS
# - docker push circleci/elasticsearch
# TODO: Run other browsers.
# https://circleci.com/docs/installing-custom-software
echo "~ Installing Bower packages."
cd content && bower install > /dev/null || exit 1 && cd ..

echo "~ Building the Docker image."
docker build -t pay-per-task.com . > /dev/null || exit 1

echo "~ Running the pay-per-task.com image."
docker run -d -p 80:80 pay-per-task.com > /dev/null || exit 1

echo "~ Installing the gems."
bundle install || exit 1

echo -e "\n~ Running the integration tests in PhantomJS."
bundle exec cucumber || exit 1

# https://circleci.com/docs/browser-debugging#interact-with-the-browser-over-vnc
echo -e "\n~ Running the integration tests in Firefox."
sudo apt-get -y install firefox > /dev/null
BROWSER=firefox bundle exec cucumber || exit 1

echo -e "\n~ Running the integration tests in Google Chrome."
sudo apt-get -y install google-chrome-stable > /dev/null
BROWSER=chrome bundle exec cucumber || exit 1

# Deployment.
$ROOT/bin/deploy.rb
