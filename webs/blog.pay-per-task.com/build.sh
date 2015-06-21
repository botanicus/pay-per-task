#!/bin/sh

# TODO: Haproxy -> API & this.
# TODO: Trigger Dockerhub build just for this repo.
# - docker login -e $DOCKER_EMAIL -u $DOCKER_USER -p $DOCKER_PASS
# - docker push circleci/elasticsearch
# TODO: Run other browsers.
# https://circleci.com/docs/installing-custom-software

echo "~ Installing NPM packages."
npm install > /dev/null

for bindir in node_modules/*/bin; do
  export PATH="$bindir:$PATH"
done
echo "\$PATH=$PATH"

echo "~ Installing the gems."
bundle install > /dev/null || exit 1

echo "~ Building dist."
webpack --progress --colors
rake generate

echo "~ Building the Docker image."
docker build -t blog.pay-per-task.com . > /dev/null || exit 1

echo "~ Running the blog.pay-per-task.com image."
docker run -d -p 80:80 blog.pay-per-task.com > /dev/null || exit 1

echo -e "\n~ Running the integration tests in PhantomJS."
mkdir $CIRCLE_ARTIFACTS/phantomjs
bundle exec cucumber -p CI || FAILED=true

# https://circleci.com/docs/browser-debugging#interact-with-the-browser-over-vnc
echo -e "\n~ Running the integration tests in Firefox."
sudo apt-get -y install firefox > /dev/null
mkdir $CIRCLE_ARTIFACTS/firefox
BROWSER=firefox bundle exec cucumber -p CI || FAILED=true

echo -e "\n~ Running the integration tests in Google Chrome."
sudo apt-get -y install google-chrome-stable > /dev/null
mkdir $CIRCLE_ARTIFACTS/chrome
BROWSER=chrome bundle exec cucumber -p CI || FAILED=true

test -z "$FAILED" || exit 1

# Deployment.
echo -e "\n\n"
$ROOT/bin/deploy.rb
