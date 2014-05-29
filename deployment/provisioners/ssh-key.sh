#!/bin/sh

# Install dev's SSH keys, so we can
# push to GitHub from within the VM.

echo "~ Copying SSH keys."
cp /host/ssh/id_rsa ~/.ssh
cp /host/ssh/id_rsa.pub ~/.ssh

# So we can push & deploy to the server.
cat > ~/.ssh/config << EOF
Host server
  HostName 178.79.138.233
  User root
  # StrictHostKeyChecking no
  # UserKnownHostsFile /dev/null
  Compression yes
EOF
