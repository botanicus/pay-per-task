#!/bin/bash

echo "~ Installing Bower packages."
cd content && bower install > /dev/null || exit 1 && cd ..

echo "~ Building the Docker image."
docker build -t pay-per-task.com . > /dev/null || exit 1

echo "~ Running the pay-per-task.com image."
docker run -d -p 80:80 pay-per-task.com > /dev/null || exit 1

echo "~ Installing protractor."
npm install protractor -g > /dev/null || exit 1

echo "~ Getting the XYZ"
webdriver-manager update > /dev/null || exit 1

echo "~ Starting the XYZ"
(webdriver-manager start &> /dev/null || exit 1) &
sleep 2.5

echo -e "\n~ Running the integration tests."
./protractor.conf.js
