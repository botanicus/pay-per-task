#!/bin/bash

echo "~ Installing Bower packages."
cd content && bower install > /dev/null || exit 1 && cd -

echo "~ Building the Docker image."
docker build -t pay-per-task.com . || exit 1

echo "~ Running pay-per-task.com."
docker run -d -p 80:80 pay-per-task.com || exit 1

echo "~ Installing protractor."
npm install protractor -g > /dev/null || exit 1

echo "~ Getting the XYZ"
webdriver-manager update || exit 1

echo "~ Starting the XYZ"
# rake ci:run:webdriver
(webdriver-manager start) &
webdriver_pid=$!
sleep 2.5

echo "~ Running the integration tests."
./protractor.conf.js
kill $webdriver_pid
