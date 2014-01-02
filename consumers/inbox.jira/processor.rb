require 'json'

# TODO: inherit this.
class Processor
  # $20 £20 €20
  def self.parse_price(title)
    match = title.match(/([£€$])(\d+)/)
    return match[2].to_i, match[1]
  end

  def self.emit(event, data)
  end

  def self.process(payload, routing_key)
    # 1 Parse.
    payload = JSON.parse(payload)

    _, service, username = routing_key.split('.')
    id    = payload['issue']['id']
    link  = payload['issue']['self']
    title = payload['issue']['fields']['summary']
    price, currency = self.parse_price(title)

    raise NoPriceDetectedError.new(title) if price.nil?

    # ACTUALLY LET'S MAKE THIS JUST A PARSER/ROUTER:
    # it parses data and then send them to a sub-service
    # next levels are not jira/pt specific unlike this
    # I don't need inheritance, I'll use services architecture for it. Ha!!!

    # self.emit(storiew.new, data)
    # ... there do this:
    # 2 Save to Redis. NOT HERE
    # story = Story.new(redis, service, username, id, price, currency, link)
    # story.save

    # new dev? -> self.emit('devs.new', data)
  end
end

__END__
Stories [created|in-progress|done|accepted] delete stories using EXPIRE

Developers
If there's a story with a dev who isn't in the system, send an email asking to fill in his details.
bank account (or sth like that; out of scope of MVP)
