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

File.open("#{ENV['HOME']}/.ssh/config", 'a') do |file|
  file.puts <<-EOF
Host bitbucket
  User git
  Hostname bitbucket.org
  IdentityFile #{ENV['ROOT']}/ssh_key
  EOF
end

# run "ssh-add #{ENV['ROOT']}/ssh_key"

repos = JSON.parse(%x{curl --user #{BITBUCKET_CREDENTIALS} #{BITBUCKET_API}/repositories/botanicus})
if repos['values'].find { |repo| repo['name'] == REPO_NAME }
  puts "~ Repository #{REPO_NAME} exists, updating."
  # clone it, replace the code, commit, push
  run "rm -rf #{ENV['ROOT']}/.git"
  run "git clone --bare bitbucket/botanicus/#{REPO_NAME}.git"
  run "git add ."
  run "git commit -a -m 'Build from #{Time.now.strftime("%Y/%m/%d %H:%M")}'"
  run "git push"
else
  puts "~ Repository #{REPO_NAME} doesn't exist yet, creating."
  json = {scm: 'git', is_private: true}.to_json
  run "curl -X POST --user #{BITBUCKET_CREDENTIALS} -H 'Content-Type: application/json' #{BITBUCKET_API}/repositories/botanicus/#{REPO_NAME}.git -d '#{json}'"
  # As of now, it's impossible to create automated builds through the API as far as I know.
  # run "curl -X PUT --user #{DOCKERHUB_CREDENTIALS} #{DOCKERHUB_API}/v1/repositories/paypertask/#{REPO_NAME}/ -v -d '[]'"
  run %{curl -X POST https://hooks.slack.com/services/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 -d '{"text": "TODO: Create an automated build for <https://registry.hub.docker.com/builds/bitbucket/botanicus/#{REPO_NAME}/|#{REPO_NAME}>. Dockerhub doesn't have API for this.", "username": "Deployment notifications", "channel": "#general"}'}
  # connect them via webhooks
  # commit & push
  # tutum?
  run "rm -rf #{ENV['ROOT']}/.git"
  run "git init"
  run "git add ."
  run "git remote add origin bitbucket/botanicus/#{REPO_NAME}.git"
  run "git push -u origin master"
end
