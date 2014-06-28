#!/usr/bin/env ruby

# The onboarding should go like:
#
# 1. Give us your API token (here are instructions how to do it).
# 2. Ta! Here's list of your projects. Click install next to each
#    project you want to install it for. You can change it later
#    from our app.
# 3. Clicking install will:
#   a) Set up the webhook URL[1].
#   b) Import all devs using GET /projects/{project_id}/memberships
#   c) Send those devs an onboarding email.
#
# [1] https://www.pivotaltracker.com/help/api/rest/v5#projects_project_id_webhooks

require 'bundler/setup'

require 'pivotal-tracker'

API_TOKEN = '78525a130a030829876309975267aa6a'

require 'pry'

# See the API? Powered by a moron dev (TM). What da fuck???
# Worse yet, it uses APIv3, I'd prefer v5, but I can live with that I guess.
PivotalTracker::Client.token = API_TOKEN

p PivotalTracker::Project.all
binding.pry
