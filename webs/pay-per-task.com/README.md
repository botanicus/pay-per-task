# About

The PPT landing page [pay-per-task.dev](http://pay-per-task.dev) baked into a minimal Nginx container.

# Dependencies

- api.pay-per-task.dev for adding newsletter subscribers and in the future also for sign-up and log-in.

# Setup

Add `$(boot2docker ip) pay-per-task.dev` to `/etc/hosts`.

Bower packages are part of the container, but not part of the repository, so you need to run `bower install` in `content/` (where the `bower.json` file is).

# Test suite

TODO!

# Status

- WIP.

- Phase I: Revisit the copy. Login isn't done – disable for now! Are cookies necessary? Do we need to load ui, animate and cookies for everyone? Set up GA (transfer account?). Newsletter sign-up.
- Estimate: 3 days.

- Phase II: Sign-up, log-in & account menu.
- Estimate: 2 days.

# Known issues

- Update dependencies.
- vhost.conf: build.html vs. app.html.
- move build functionality into the Rakefile.
- We're using `sendfile off` to make VirtualBox happy in development.
