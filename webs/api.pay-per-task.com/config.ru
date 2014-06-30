#!/usr/bin/env rackup

require 'ppt'

require 'json'
require 'sinatra'
require 'gibbon'
require 'http'

DEVELOPMENT = true

if DEVELOPMENT
  PROTOCOL = 'http'
  DOMAIN = 'pay-per-task.dev'
else
  PROTOCOL = 'http'
  DOMAIN = 'pay-per-task.com'
end

# CORS.
before do
  content_type :json
  headers 'Access-Control-Allow-Origin'  => "#{PROTOCOL}://#{DOMAIN}",
          'Access-Control-Allow-Headers' => ['Content-Type', '*'].join(', '),
          'Access-Control-Allow-Credentials' => 'true',
          'Access-Control-Allow-Methods' => ['OPTIONS', 'GET', 'POST', 'PUT'].join(', ')
end

# Helpers.
helpers do
  def gravatar_link(email)
    require 'digest/md5'

    email_md5 = Digest::MD5.hexdigest(email)

    # TODO: Check if it returns 404.
    "http://www.gravatar.com/avatar/#{email_md5}?size=50&default=404"
  end

  def current_user
    # return if session[:username].nil?
    # return User.find(session[:username])
    if session[:email] == 'james@101ideas.cz'
      return {
        name: "James C Russell",
        stats: {
          "Done" => "20 stories at $1250",
          "WIP"  => "4 stories at $350"
        },
        email: 'james@101ideas.cz',
        gravatarLink: gravatar_link('james@101ideas.cz')
      }
    end
  end
end


# Pre-onboarding.
post '/subscribe' do
  # TODO: Make it a separate class.
  config    = PPT.config('mailchimp')
  mailchimp = Gibbon::API.new(config[:api_key])

  begin
    p data = JSON.parse(env['rack.input'].read)
    config[:lists].each do |list_id| # mailchimp.lists.list
      mailchimp.lists.subscribe(id: list_id, email: {email: data['email']})
    end

    status 201
  rescue => error
    status 500
    body error.message
  end
end

# Onboarding.
#
# It should go like:
#
# 1. Create a new user. We only need to know which service the user
#    wants to use. We'll get his details from the API as soon as we
#    get our dirty hands on his API key. This might not work for
#    everything, but I just like to make the onboarding seamless.
#
# 2. Give us your API token (here are instructions how to do it).
#
# 3. Ta! Here's list of your projects[1]. Click install next to each
#    project you want to install[2] it for. You can change it later
#    from our app.
#
# 4. Clicking install will:
#   a) Set up the webhook URL[x].
#   b) Import all devs using GET /projects/{project_id}/memberships[y]
#   c) Send those devs an onboarding email.
#
# 5. Charge his card & set up periodic payments.
#
# [1] curl -H "X-TrackerToken: 78525a130a030829876309975267aa6a" https://www.pivotaltracker.com/services/v5/projects
# [2] curl -X POST -H "X-TrackerToken: 78525a130a030829876309975267aa6a" -H "Content-Type: application/json" -d '{"webhook_url": "http://in.pay-per-task.com/pt/ppt/Wb9CdGTqEr7msEcPBrHPinsxRxJdM", "webhook_version": "v5"}' https://www.pivotaltracker.com/services/v5/projects/957456/webhooks
#
# [x] https://www.pivotaltracker.com/help/api/rest/v5#projects_project_id_webhooks
# [y] https://www.pivotaltracker.com/help/api/rest/v5#projects_project_id_memberships_get

helpers do
  def pivotal_tracker(method, api_path, token, extra_opts = Hash.new)
    path = "https://www.pivotaltracker.com/services/v5#{api_path}"
    HTTP.with('X-TrackerToken' => token).send(method, path, extra_opts)
  end
end

post '/users' do
  require 'ppt/models'

  # service token plan
  p user_data = JSON.parse(env['rack.input'].read)

  if user_data['service'] == 'pt'
    response = pivotal_tracker(:get, '/me', user_data['token'])
    data = JSON.parse(response.body.readpartial)
    me = data.select { |key, _| ['email', 'name', 'username'].include?(key) }

    user = PPT::DB::User.new(me) # TODO: would be better with a block
    user.service = user_data['service']
    user.pt.api_key = user_data['token']
    user.plan = user_data['plan']
    user.save
    p user

    me['projects'] = data['projects'].map do |item|
      item.reduce(Hash.new) do |buffer, (key, value)|
        buffer[:id]   = value if key == 'project_id'
        buffer[:name] = value if key == 'project_name'
        buffer
      end
    end

    me.to_json
  else
    raise 'Not implemented error.'
  end
end

# AngularJS requires that.
options '/users' do
  status 200
end

post '/onboarding/pt/:token/hooks/:project' do
  body = {webhook_url: XXX, webhook_version: 'v5'}
  api_path = "/projects/#{params[:project]}/webhooks"
  response = pivotal_tracker(:post, api_path, params[:token], json: body)

  status response.status
end

# API.
get '/me' do
  if current_user
    body current_user.to_json
    status 200
  else
    status 401
  end
end

# AngularJS requires that.
options '/me' do
  status 200
end

post '/me' do
  p data = JSON.parse(request.body.read)

  if data['email'] == 'james@101ideas.cz' && data['password'] == 'password'
    session[:email] = data['email']
    body current_user.to_json
    status 200
  else
    session.delete(:email)
    status 401
  end

  puts "~ Session #{session.inspect}"
end

# Cookies.
use Rack::Session::Cookie, key: 'session', domain: ".#{DOMAIN}", httponly: false, secret: '79APgXadpzJswvQuGFsoTaRjXabBEZ'

run Sinatra::Application
