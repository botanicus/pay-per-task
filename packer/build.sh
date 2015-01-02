#!/bin/sh

set -e

export PACKER_LOG=1
rm ubuntu-14.10-amd64.box || true
packer build -only virtualbox-iso packer.json
mv packer_virtualbox-iso_virtualbox.box ubuntu-14.10-amd64.box # TODO: Can I do this in packer.json?
vagrant box remove ubuntu-14.10-amd64 --force || true
vagrant box add ubuntu-14.10-amd64 ubuntu-14.10-amd64.box
