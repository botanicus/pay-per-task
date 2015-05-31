# About

Shared resources baked into a minimal Nginx container.

# Setup

Add `$(boot2docker ip) cdn.pay-per-task.dev` to `/etc/hosts`.

# Status

Working. Development finished.

# Known issues

- In dev it seems to be really slow. Investigate why.
- We're using `sendfile off` to make VirtualBox happy in development.
