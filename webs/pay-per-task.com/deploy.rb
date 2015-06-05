#!/usr/bin/env ruby

require 'json'

BITBUCKET_CREDENTIALS = 'botanicus:i3Pn4ZsLLoauDE'
BITBUCKET_API = 'https://api.bitbucket.org/2.0'

DOCKERHUB_CREDENTIALS = 'paypertask:kHcmLuXMiwnG6VQBjMtauoGG3pLvuF'
DOCKERHUB_API = 'https://registry.hub.docker.com'

REPO_NAME = File.basename(Dir.pwd)

repos = JSON.parse(%x{curl --user #{BITBUCKET_CREDENTIALS} #{BITBUCKET_API}/repositories/botanicus})
if repos['values'].find { |repo| repo['name'] == REPO_NAME }
  puts "~ Repository #{REPO_NAME} exists, updating."
  # clone it, replace the code, commit, push
  system "rm -rf #{ENV['ROOT']}/.git"
  system "git clone --bare ssh://git@bitbucket.org/botanicus/#{REPO_NAME} .git"
  system "git add ."
  system "git commit -a -m 'Build from #{Time.now.strftime("%Y/%m/%d %H:%M")}'"
  system "git push"
else
  puts "~ Repository #{REPO_NAME} doesn't exist yet, creating a PUBLIC one."
  system "curl -X POST --user #{BITBUCKET_CREDENTIALS} #{BITBUCKET_API}/repositories/botanicus/#{REPO_NAME} -d {\"scm\": \"git\"}"
  # As of now, it's impossible to create automated builds through the API as far as I know.
  # system "curl -X PUT --user #{DOCKERHUB_CREDENTIALS} #{DOCKERHUB_API}/v1/repositories/paypertask/#{REPO_NAME}/ -v -d '[]'"
  puts ">>> CREATE automated build. So far this isn't supported in the API."
  # connect them via webhooks
  # commit & push
  # tutum?
  system "rm -rf #{ENV['ROOT']}/.git"
  system "git add ."
  system "git remote add origin ssh://git@bitbucket.org/botanicus/#{REPO_NAME}"
  system "git push -u origin master"
end
