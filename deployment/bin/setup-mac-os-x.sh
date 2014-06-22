#!/bin/zsh

#
# This is a ZSH script. OS X comes with ZSH by default.
#

# The repo was cloned from GitHub, so GitHub is the origin.
echo "~ Renaming remote 'origin' to 'github'."
git remote rename origin github 2> /dev/null

# Add server.
echo "~ Adding Git remote 'server' for deployment."
git remote add server server:/repos/ppt 2> /dev/null

# Set up an alias to git deploy.

# Version 1:
# git config alias.deploy 'push server'
#
# Version 2:
# git config alias.deploy "\!sh -c 'test -z \"\$1\" && git push server \$(git rev-parse --abbrev-ref HEAD) || git push server master' -"
#
# Version 3:
#
# There has to be a better solution. Maybe something with read?
git_deploy_script=$(cat <<EOF
  force  = ARGV.delete("-f") || ARGV.delete("--force") || ""
  branch = ARGV.shift || %x(git rev-parse --abbrev-ref HEAD).chomp

  if ! ARGV.empty? || branch == "-h" || branch == "--help"
    abort <<-HELP
Usage: git deploy [branch] [-f]

Branch is optional, current branch is used by default.
Option -f or --force is for forced update.
    HELP
  end

  puts "~ git push server #{branch} #{force}\\n\\n"
  system "git push server #{branch} #{force}"
EOF)

echo "~ Creating git deploy alias. Run it to deploy to production."
git config alias.deploy "!ruby -e '$git_deploy_script' --"

# Make sure to push to master before deploying.
echo "~ Creating pre-push Git hook to make sure that 'github' is always updated first when we deploy."
tee .git/hooks/pre-push > /dev/null <<EOF
#!/bin/sh

IFS=' '
while read local_ref local_sha remote_ref remote_sha; do
  branch=\$(basename \$remote_ref)
  if test \$branch = \$1; then
    echo "~ Pushing branch '\$branch' to GitHub first."
    git push github \$branch &> /dev/null
  fi
done
EOF

chmod +x .git/hooks/pre-push

# Install Vagrant plugin which enables us to set up port forwarding when Vagrant boots up.
if ! vagrant plugin list | egrep vagrant-triggers > /dev/null; then
  echo "~ Installing vagrant-triggers."
  vagrant plugin install vagrant-triggers
fi

# Disable asking your password every time you run vagrant [up|halt]:
if ! egrep 'ADDED BY PPT SETUP SCRIPT' /etc/sudoers > /dev/null; then
  echo "~ Sudo won't require password anymore. This is because of vagrant-triggers, so we don't have to type sudo every time we do vagrant up. It should be changed to not to ask password only for this purpose, but I couldn't figure out how to do it."
  sudo tee -a /etc/sudoers > /dev/null <<EOF

# ADDED BY PPT SETUP SCRIPT
# This enables all the users in the wheel group to run any command with sudo without password.
# We're using it for port forwarding. It'd be best to allow only the pfctl command to be run
# without password, but James couldn't figure out why nor did he consider it a priority.
# In fact it's rather handy. Here we go then:
%wheel ALL=(ALL) NOPASSWD: ALL
EOF
fi

domains=(
  in.pay-per-task.dev
  api.pay-per-task.dev

  in.pay-per-task.test
  api.pay-per-task.test

  pay-per-task.dev
  app.pay-per-task.dev
  blog.pay-per-task.dev
  cdn.pay-per-task.dev
  docs.pay-per-task.dev
)

for domain in $domains; do
  if ! egrep $domain /etc/hosts > /dev/null; then
    echo "~ Adding 127.0.0.1 $domain to /etc/hosts so it can be accessed via $domain instead using some crazy port number."
    echo "127.0.0.1 $domain" | sudo tee -a /etc/hosts > /dev/null
  fi
done

if ! egrep 'Host server' ~/.ssh/config > /dev/null; then
  echo "~ Adding SSH configuration for the production server."
  tee -a ~/.ssh/config > /dev/null <<EOF
# PPT Linode server.
Host server
  HostName 178.79.138.233
  User root
  compression yes
EOF
fi
