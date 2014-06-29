#!/usr/bin/env rackup

require 'bundler/setup'

require 'ppt'

require 'json'
require 'sinatra'
require 'gibbon'

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
