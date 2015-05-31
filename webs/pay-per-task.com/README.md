# About

The PPT landing page [pay-per-task.dev](http://pay-per-task.dev) baked into a minimal Nginx container.

# Dependencies

- api.pay-per-task.dev for adding newsletter subscribers.

# Setup

Add `$(boot2docker ip) pay-per-task.dev` to `/etc/hosts`.

Bower packages are part of the container, but not part of the repository, so you need to run `bower install` in `content/` (where the `bower.json` file is).

# Test suite

TODO!

# Status

- WIP, mostly done.

# Known issues

- Update dependencies.
- vhost.conf: build.html vs. app.html.
- move build functionality into the Rakefile.
- We're using `sendfile off` to make VirtualBox happy in development.
