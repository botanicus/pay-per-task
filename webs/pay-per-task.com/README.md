# About

The PPT landing page [pay-per-task.dev](http://pay-per-task.dev) baked into a minimal Nginx container.

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

TODO!

# Status

- WIP. Both the copy and the functionality needs to be revisited. Basic styling needed, CI & deployment to be set up.

# Known issues

- Update dependencies.
- vhost.conf: build.html vs. app.html.
- move build functionality into the Rakefile.
- We're using `sendfile off` to make VirtualBox happy in development.
