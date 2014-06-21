source 'https://rubygems.org'

# Tools.
gem 'assets-squasher', github: 'botanicus/assets-squasher', branch: 'master'

# Services.
gem 'pipeline-mail_queue', github: 'botanicus/pipeline-mail_queue', branch: 'master'
gem 'ppt.inbox.backup', github: 'boll.ocks', branch: 'master'
gem 'ppt.inbox.pt', github: 'boll.ocks', branch: 'master'
gem 'ppt.inbox.jira', github: 'boll.ocks', branch: 'master'

# Dependencies.
#
# Those are specified in each repo's gemspec.
# Gemspec however cannot work with Git repos.
#
# DO make sure to push those to Github before
# doing the deployment!
#
# Or maybe bundle install --deployment is enough?

gem 'simple-orm', github: 'botanicus/simple-orm', branch: 'master'


# Private dependencies.
#
# For each of those run the following command:
# bundle config local.{gem} /webs/ppt/gems/{gem}.
#
# Fair question is why the fuck do we have to specify
# git and branch when for crying out loud it's in the
# same motherfucking repository! Well, that's because
# smart chaps from bundler simply didn't thought of
# the scenario where you have a local repository
# which you don't want to install through git
# (since it already is in the motherfucking repo).
#
# It has been reported: https://github.com/bundler/bundler/issues/3074
gem 'ppt', git: 'boll.ocks', branch: 'master'

# Development.
group(:development) do
  gem 'pry'
end
