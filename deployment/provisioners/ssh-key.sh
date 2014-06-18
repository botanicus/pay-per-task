#!/bin/sh

# Install dev's SSH keys, so we can
# push to GitHub from within the VM.

echo "~ Copying SSH keys."
cp /host/ssh/id_rsa ~/.ssh
cp /host/ssh/id_rsa.pub ~/.ssh
