#!/usr/bin/env bundle exec rackup -s Puma -p 4001

API_KEY = '49c462153a6ef57de56ad49fc388396e-us3'
LIST_ID = 'eaf78103d9' # mailchimp.lists.list

require 'json'
require 'gibbon'

mailchimp = Gibbon::API.new(API_KEY)

run Proc.new { |env|
  begin
    data = JSON.parse(env['rack.input'].read)
    mailchimp.lists.subscribe(id: LIST_ID, email: {email: data['email']})
    [201, Hash.new, []]
  rescue => error
    headers = {'Content-Type' => 'text/plain', 'Content-Length' => error.message.bytesize.to_s}
    [500, headers, [error.message]]
  end
}
