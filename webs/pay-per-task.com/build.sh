#!/bin/bash

echo "~ Installing Bower packages."
cd content && bower install > /dev/null && cd -

echo "~ Building the Docker image."
docker build -t pay-per-task.com .

echo "~ Running pay-per-task.com."
docker run -d -p 80:80 pay-per-task.com

echo "~ Installing protractor."
npm install protractor #> /dev/null

echo "~ Getting the XYZ"
webdriver-manager update

echo "~ Starting the XYZ"
webdriver-manager start &
sleep 2.5

echo "~ Running the integration tests."
./protractor.conf.js
