#!/usr/bin/env ruby

# The onboarding should go like:
#
# 1. Create a new user with a unique auth_key.
# 2. Give us your API token (here are instructions how to do it).
# 3. Ta! Here's list of your projects[1]. Click install next to each
#    project you want to install[2] it for. You can change it later
#    from our app.
# 4. Clicking install will:
#   a) Set up the webhook URL[x].
#   b) Import all devs using GET /projects/{project_id}/memberships
#   c) Send those devs an onboarding email.
#
# [1] curl -H "X-TrackerToken: 78525a130a030829876309975267aa6a" https://www.pivotaltracker.com/services/v5/projects
# [2] curl -X POST -H "X-TrackerToken: 78525a130a030829876309975267aa6a" -H "Content-Type: application/json" -d '{"webhook_url": "http://in.pay-per-task.com/pt/ppt/Wb9CdGTqEr7msEcPBrHPinsxRxJdM", "webhook_version": "v5"}' https://www.pivotaltracker.com/services/v5/projects/957456/webhooks
# [x] https://www.pivotaltracker.com/help/api/rest/v5#projects_project_id_webhooks

require 'bundler/setup'

require 'http'

API_TOKEN = '78525a130a030829876309975267aa6a'

require 'pry'

# See the API? Powered by a moron dev (TM). What da fuck???
# Worse yet, it uses APIv3, I'd prefer v5, but I can live with that I guess.
PivotalTracker::Client.token = API_TOKEN

p PivotalTracker::Project.all
binding.pry
