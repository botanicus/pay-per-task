# About

The PPT blog [blog.pay-per-task.dev](http://blog.pay-per-task.dev) baked into a minimal Nginx container.

This is using [blog-generator](https://github.com/botanicus/blog-generator) to generate the static blog API.

# Setup

Add `$(boot2docker ip) blog.pay-per-task.dev` to `/etc/hosts`.

Bower packages are part of the container, but not part of the repository, so you need to run `bower install` in `content/` (where the `bower.json` file is).

webpack --progress --colors --watch

# Test suite

TODO!

# Status

- WIP. Add CSS.

# Known issues

- Explain that Ruby is not a runtime dependency and how to generate the posts.
- Update dependencies.
- vhost.conf: /api is kind of awkward.
- vhost.conf: build.html vs. app.html.
- move build functionality into the Rakefile.
- We're using `sendfile off` to make VirtualBox happy in development.

# TODO

- GA.
- Disquis.
