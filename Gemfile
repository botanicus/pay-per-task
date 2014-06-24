source 'https://rubygems.org'

# Tools.
gem 'assets-squasher', github: 'botanicus/assets-squasher', branch: 'master'

# Services.
gem 'pipeline-mail_queue', github: 'botanicus/pipeline-mail_queue', branch: 'master'
gem 'ppt.inbox.backup', path: 'gems/ppt.inbox.backup'
gem 'ppt.inbox.pt', path: 'gems/ppt.inbox.pt'
gem 'ppt.inbox.jira', path: 'gems/ppt.inbox.jira'

# Dependencies.
#
# Those are specified in each repo's gemspec.
# Gemspec however cannot work with Git repos and local paths.
#
# DO make sure to push those to GitHub before
# doing the deployment!
#
# bundle install --deployment --without development,test

gem 'ppt', path: 'gems/ppt'
gem 'simple-orm', github: 'botanicus/simple-orm', branch: 'master'

# Development.
group(:development) do
  gem 'pry'
end
