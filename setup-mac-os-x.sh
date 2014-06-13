#!/bin/sh

# The repo was cloned from GitHub, so GitHub is the origin.
git remote rename origin github

# Add server.
git remote add server server:/repos/ppt

# Set up Git remote tracking.
git push --set-upstream github master
git push --set-upstream server master

# Set up alias to git deploy.

#git config alias.deploy 'push server'
# TODO: This should support -f for forced deployments.
git config alias.deploy "\!sh -c 'test -z \"\$1\" && git push server \$(git rev-parse --abbrev-ref HEAD) || git push server master' -"

# Make sure to push to master before deploying.
tee .git/hooks/pre-push <<EOF
#!/bin/sh

IFS=' '
while read local_ref local_sha remote_ref remote_sha; do
  branch=$(basename $remote_ref)
  echo "~ Updating '$branch' branch first."
  git push origin $branch &> /dev/null
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
127.0.0.1 in.pay-per-task.dev
127.0.0.1 api.pay-per-task.dev

127.0.0.1 in.pay-per-task.test
127.0.0.1 api.pay-per-task.test

127.0.0.1 pay-per-task.dev
127.0.0.1 app.pay-per-task.dev
127.0.0.1 blog.pay-per-task.dev

127.0.0.1 docs.pay-per-task.dev
EOF

tee -a ~/.ssh/config <<EOF
# PPT Linode server.
Host server
  HostName 178.79.138.233
  User root
  compression yes
EOF
