#!/usr/bin/env bundle exec rackup -s thin -p 4002

require 'json'
require 'sinatra'

# DOMAIN = 'pay-per-task.com'
DOMAIN = 'http://localhost:4000'

before do
  content_type :json
  headers 'Access-Control-Allow-Origin'  => DOMAIN,
          'Access-Control-Allow-Headers' => ['Content-Type', '*'].join(', '),
          'Access-Control-Allow-Credentials' => 'true',
          'Access-Control-Allow-Methods' => ['OPTIONS', 'GET', 'POST', 'PUT'].join(', ')
end

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
      return {name: "James C Russell", email: 'james@101ideas.cz', gravatarLink: gravatar_link('james@101ideas.cz')}
    end
  end
end

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

enable :sessions
set :session_secret, '79APgXadpzJswvQuGFsoTaRjXabBEZ'
set :session_domain, DOMAIN

# use Rack::Session::Cookie, key: 'rack.session',  domain: DOMAIN, secret: '79APgXadpzJswvQuGFsoTaRjXabBEZ'

run Sinatra::Application
