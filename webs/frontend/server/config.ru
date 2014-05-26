#!/usr/bin/env bundle exec rackup -s thin -p 4002

require 'json'
require 'sinatra'

before do
  content_type :json
  headers 'Access-Control-Allow-Origin'  => '*',
          'Access-Control-Allow-Methods' => ['OPTIONS', 'GET', 'POST'].join(', ')
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
    # session[:username]
    return {username: 'botanicus', name: "James C Russell", email: 'james@101ideas.cz', gravatarLink: gravatar_link('james@101ideas.cz')}
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

run Sinatra::Application
