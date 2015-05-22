#!/bin/sh

set -e

export PACKER_LOG=1

# When upgrading, this would be the previous version. Glob fails in the shell, so STDERR redirect doesn't solve it.
rm ubuntu-15.04-amd64.box || true

packer build -only virtualbox-iso packer.json
mv packer_virtualbox-iso_virtualbox.box ubuntu-15.04-amd64.box # TODO: Can I do this in packer.json?

# When upgrading, this would be the previous version.
vagrant box remove ubuntu-15.04-amd64 --force || true

vagrant box add ubuntu-15.04-amd64 ubuntu-15.04-amd64.box
