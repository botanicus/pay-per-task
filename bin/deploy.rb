#!/usr/bin/env ruby

require 'json'

BITBUCKET_CREDENTIALS = 'botanicus:i3Pn4ZsLLoauDE'
BITBUCKET_API = 'https://api.bitbucket.org/2.0'

DOCKERHUB_CREDENTIALS = 'paypertask:kHcmLuXMiwnG6VQBjMtauoGG3pLvuF'
DOCKERHUB_API = 'https://registry.hub.docker.com'

REPO_NAME = File.basename(Dir.pwd)

def run(command)
  puts "~ #{command}"
  system command
end

puts "~ Running the deploy script."

# ENV['GIT_SSH_COMMAND'] = "ssh -i #{ENV['ROOT']}/ssh_key"

run "chmod 600 #{ENV['ROOT']}/ssh_key"
run "git config --global user.email 'info@pay-per-task.com'"
run "git config --global user.name 'Deployer'"

File.open("#{ENV['HOME']}/.ssh/config", 'a') do |file|
  file.puts <<-EOF
Host bitbucket
  User git
  Hostname bitbucket.org
  IdentityFile #{ENV['ROOT']}/ssh_key
  EOF
end

repos = JSON.parse(%x{curl --user #{BITBUCKET_CREDENTIALS} #{BITBUCKET_API}/repositories/botanicus})
if repos['values'].find { |repo| repo['name'] == REPO_NAME }
  puts "~ Repository #{REPO_NAME} exists, updating."
  # clone it, replace the code, commit, push
  run "rm -rf #{ENV['ROOT']}/.git"
  run "git clone --bare ssh://bitbucket/botanicus/#{REPO_NAME}.git .git"
  run "git config core.bare false" # Haha LOL.
  run "git add ."
  run "git commit -a -m 'Build from #{Time.now.strftime("%Y/%m/%d %H:%M")}'"
  run "git push -f origin master"
else
  puts "~ Repository #{REPO_NAME} doesn't exist yet, creating."
  json = {scm: 'git', is_private: true}.to_json
  run "curl -X POST --user #{BITBUCKET_CREDENTIALS} -H 'Content-Type: application/json' #{BITBUCKET_API}/repositories/botanicus/#{REPO_NAME} -d '#{json}'"
  run "rm -rf #{ENV['ROOT']}/.git"
  run "git init"
  run "git add ."
  run "git remote add origin ssh://bitbucket/botanicus/#{REPO_NAME}.git"
  run "git commit -a -m 'Initial import from #{Time.now.strftime("%Y/%m/%d %H:%M")}'"
  run "git push -u origin master"
  # run "curl -X PUT --user #{DOCKERHUB_CREDENTIALS} #{DOCKERHUB_API}/v1/repositories/paypertask/#{REPO_NAME}/ -v -d '[]'"
  run %{curl -X POST https://hooks.slack.com/services/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 -d '{"text": "@botanicus: Please create <https://registry.hub.docker.com/builds/bitbucket/botanicus/#{REPO_NAME}/|#{REPO_NAME} automated build>. Dockerhub does not have API for this.", "username": "Deployment notifications", "channel": "#general"}'}
  # tutum?
end
