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

echo "~ Installing the gems."
bundle install || exit 1

echo "~ Building posts."
mkdir -p dist/api
# This has to run first so we can use metadata.json from BlogApp.js.
rake generate

echo "~ Building assets."
grunt copy
webpack.js --config webpack.dist.config.js --colors

echo "~ Building the Docker image."
docker build -t blog.pay-per-task.com . > /dev/null || exit 1

echo "~ Running the blog.pay-per-task.com image."
docker run -p 80:80 blog.pay-per-task.com > /dev/null &

SITE=$(basename $PWD)

echo "\n~ Running the integration tests in PhantomJS."
mkdir -p $CIRCLE_ARTIFACTS/$SITE/phantomjs
bundle exec cucumber -p CI || FAILED=true

# https://circleci.com/docs/browser-debugging#interact-with-the-browser-over-vnc
echo "\n~ Running the integration tests in Firefox."
sudo apt-get -y install firefox > /dev/null
mkdir -p $CIRCLE_ARTIFACTS/$SITE/firefox
BROWSER=firefox bundle exec cucumber -p CI || FAILED=true

echo "\n~ Running the integration tests in Google Chrome."
sudo apt-get -y install google-chrome-stable > /dev/null
mkdir -p $CIRCLE_ARTIFACTS/$SITE/chrome
BROWSER=chrome bundle exec cucumber -p CI || FAILED=true

test -z "$FAILED" || exit 1

# Deployment.
echo -e "\n\n"
$ROOT/bin/deploy.rb
