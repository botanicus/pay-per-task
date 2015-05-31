# About

The PPT blog [blog.pay-per-task.dev](http://blog.pay-per-task.dev) baked into a minimal Nginx container.

# Setup

Add `$(boot2docker ip) blog.pay-per-task.dev` to `/etc/hosts`.

Bower packages are part of the container, but not part of the repository, so you need to run `bower install` in `content/` (where the `bower.json` file is).

# Test suite

TODO!

# Status

- WIP. Add CSS. generate.rb crashes.

# Known issues

- No Gemfile?
- Explain that Ruby is not a runtime dependency and how to generate the posts.
- Update dependencies.
- vhost.conf: /api is kind of awkward.
- vhost.conf: build.html vs. app.html.
- move build functionality into the Rakefile.
- We're using `sendfile off` to make VirtualBox happy in development.



`posts/2014-06-03-are-you-losing-money-because-of-lack-of-documentation.html`

```html
tags: ['documentation', 'doxxu']
#updated: 2014-06-05 # only if you want to show when the post was updated.
#published: false
---
<div id="excerpt">
  ...
</div>

<p>
  First things first ...
</p>
```

# TODO

- GA.
- Disquis.
