#!/bin/sh

# Set up alias to git deploy.
git config alias.deploy 'push origin master:deployment'

# Make sure to push to master before deploying.
tee .git/hooks/pre-push <<EOF
#!/bin/sh

IFS=' '
while read local_ref local_sha remote_ref remote_sha; do
  if [ $(basename $remote_ref) = "deployment" ]; then
    echo "~ Updating master branch first."
    git push origin master &> /dev/null
  fi
done
EOF

chmod +x .git/hooks/pre-push

# Install Vagrant plugin which enables us to set up port forwarding when Vagrant boots up.
vagrant plugin install vagrant-triggers

# Disable asking your password every time you run vagrant [up|halt]:
sudo tee -a /etc/sudoers <<EOF
# This enables all the users in the wheel group to run any command with sudo without password.
# We're using it for port forwarding. It'd be best to allow only the pfctl command to be run
# without password, but James couldn't figure out why nor did he consider it a priority.
# In fact it's rather handy. Here we go then:
%wheel ALL=(ALL) NOPASSWD: ALL
EOF

sudo tee -a /etc/hosts <<EOF
# PPT Domains for Local Development.
127.0.0.1 pay-per-task.dev
127.0.0.1 api.pay-per-task.dev
127.0.0.1 app.pay-per-task.dev
127.0.0.1 raw.pay-per-task.dev
127.0.0.1 docs.pay-per-task.dev

127.0.0.1 api.pay-per-task.test

tee -a ~/.ssh/config <<EOF
# PPT Linode server.
Host server
  HostName 178.79.138.233
  User root
  compression yes
EOF
