# About

The PPT landing page [pay-per-task.dev](http://pay-per-task.dev) baked into a minimal Nginx container.

**Links**:
[CI](https://circleci.com/gh/botanicus/pay-per-task) |
[GitHub](https://github.com/botanicus/pay-per-task) |
[BitBucket](https://bitbucket.org/botanicus/pay-per-task.com/commits) mirror |
[Dockerhub](https://registry.hub.docker.com/builds/bitbucket/botanicus/pay-per-task.com/)
[Tutum](https://dashboard.tutum.co/node/show/76b63c37-1828-4d02-9182-8b174e578229/)

# Dependencies

[api.pay-per-task.dev](http://docs.pay-per-task.dev/webs/api.pay-per-task.dev)
  - Subscribe to the newsletter.
  - [FUTURE] Sign-up, log-in and onboarding.

# Setup

```
for domain in pay-per-task.dev api.pay-per-task.dev; do
  echo "$(boot2docker ip) api.pay-per-task.dev" | sudo tee -a /etc/hosts
done
```

Bower packages are part of the container, but not part of the repository, so you need to run `bower install` in `content/` (where the `bower.json` file is).

NOTE: This will probably change, as for automatic build of the image there doesn't seem to be any hooks, so we might have to include those anyway. To be sorted as port of #96176258.

# Test suite

```
npm install -g protractor

./protractor.conf.js
BROWSER=chrome ./protractor.conf.js
BROWSER=firefox ./protractor.conf.js
BROWSER=safari ./protractor.conf.js
./protractor.conf.js --specs tests/features/contact.js

BROWSER=chrome rake test
```

# Status

- WIP. Both the copy and the functionality needs to be revisited. Basic styling needed, CI & deployment to be set up.

# Known issues

- Update dependencies.
- vhost.conf: build.html vs. app.html.
- move build functionality into the Rakefile.
- We're using `sendfile off` to make VirtualBox happy in development.
