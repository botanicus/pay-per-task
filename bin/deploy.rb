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

def edit_ignores
  ignores = File.foreach('.gitignore').map(&:chomp)
  ignores -= ['dist', 'content']
  File.open('.gitignore', 'w') do |file|
    file.puts(ignores)
  end
end

# Add to instructions for Slack:
# Go to your Bitbucket repo settings, find the Hooks section, and add https://hooks.slack.com/services/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 as a POST URL.
repos = JSON.parse(%x{curl --user #{BITBUCKET_CREDENTIALS} #{BITBUCKET_API}/repositories/botanicus})

if repos['values'].find { |repo| repo['name'] == REPO_NAME }
  puts "~ Repository #{REPO_NAME} exists, updating."
  # clone it, replace the code, commit, push
  run "rm -rf #{ENV['ROOT']}/.git"
  run "git clone --bare ssh://bitbucket/botanicus/#{REPO_NAME}.git .git"
  run "git config core.bare false" # Haha LOL
  edit_ignores
  run "git add ."
  # https://circleci.com/docs/environment-variables
  # TODO: Don't use CIRCLE_COMPARE_URL, if the build failed before, those changes would NOT be included!
  run "git commit -a -m 'Build from #{Time.now.strftime("%Y/%m/%d %H:%M")} GH #{ENV['CIRCLE_COMPARE_URL']} | CI https://circleci.com/gh/botanicus/pay-per-task/#{ENV['CIRCLE_BUILD_NUM']}'."
  run "git push -f origin master"
else
  puts "~ Repository #{REPO_NAME} doesn't exist yet, creating."
  json = {scm: 'git', is_private: true}.to_json
  run "curl -X POST --user #{BITBUCKET_CREDENTIALS} -H 'Content-Type: application/json' #{BITBUCKET_API}/repositories/botanicus/#{REPO_NAME} -d '#{json}'"
  run "rm -rf #{ENV['ROOT']}/.git"
  run "git init"
  edit_ignores
  run "git add ."
  run "git remote add origin ssh://bitbucket/botanicus/#{REPO_NAME}.git"
  run "git commit -a -m 'Initial import from #{Time.now.strftime("%Y/%m/%d %H:%M")}'"
  run "git push -u origin master"
  # run "curl -X PUT --user #{DOCKERHUB_CREDENTIALS} #{DOCKERHUB_API}/v1/repositories/paypertask/#{REPO_NAME}/ -v -d '[]'"
  text = DATA.read.gsub('#{REPO_NAME}', REPO_NAME).gsub(/\n/, '\n')
  run %{curl -X POST https://hooks.slack.com/services/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 -d '{"text": text, "username": "Deployment notifications", "channel": "#general"}'}
  # https://dashboard.tutum.co/container/service/show/30bc8721-55c3-4216-8172-b6386ae95627/#container-triggers -> generate
  # https://registry.hub.docker.com/u/paypertask/pay-per-task.com/settings/webhooks/ -> add the generated URL
  # tutum?
end

__END__
@botanicus:

1. Please create <https://registry.hub.docker.com/builds/bitbucket/botanicus/#{REPO_NAME}/|#{REPO_NAME} automated build>. Dockerhub does not have API for this.
2. <https://registry.hub.docker.com/u/paypertask/#{REPO_NAME}/settings/deploykeys/|Add a deployment key>.
3. Also add `https://registry.hub.docker.com/hooks/bitbucket` to <https://bitbucket.org/botanicus/#{REPO_NAME}/admin/hooks|#{REPO_NAME} hooks> (type `POST`).
4. Add <https://registry.hub.docker.com/u/paypertask/#{REPO_NAME}/settings/webhooks/add|Dockerhub webhooks>
5. Then deploy it <https://dashboard.tutum.co/container/launch/#tab-image-privates|from private> or <https://dashboard.tutum.co/container/launch/#tab-image-community|from public build>. Do not forget to:
  - Expose and map ports and make them published if necessary.
  - Turn autorestart on.
  - Maybe some links and volumes?
