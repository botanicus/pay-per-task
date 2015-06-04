#!/bin/bash

cd content && bower install > /dev/null && cd -

docker build -t pay-per-task.com .
docker run -d -p 80:80 pay-per-task.com

npm install protractor > /dev/null
webdriver-manager update

webdriver-manager start &
sleep 2.5

echo "~ Running the integration tests."
./protractor.conf.js
