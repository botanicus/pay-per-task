#!/bin/sh

set -e

export PACKER_LOG=1
rm packer_virtualbox-iso_virtualbox.box || true
packer build -only virtualbox-iso packer.json
vagrant box remove ubuntu-14.10-amd64 || true
vagrant box add ubuntu-14.10-amd64 packer_virtualbox-iso_virtualbox.box
