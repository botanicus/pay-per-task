class PPT
  module Jira
    class Processor < PPT::Processor
      def build_story(service, username, payload)
        id    = payload['issue']['id']
        link  = payload['issue']['self']
        title = payload['issue']['fields']['summary']
        price, currency = self.parse_price(title)

        raise NoPriceDetectedError.new(title) if price.nil?

        Story.new(service, username, id, price, currency, link)
      end

      def build_developer(service, username, payload)
        Developer.new(service, username)
      end
    end
  end
end
