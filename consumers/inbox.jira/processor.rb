class PPT
  module Jira
    class Processor < PPT::Processor
      def build_story(service, username, payload)
        id    = payload['issue']['id']
        link  = payload['issue']['self']
        title = payload['issue']['fields']['summary']
        price, currency = self.parse_price(title)

        raise PPT::NoPriceDetectedError.new(title) if price.nil?

        PPT::Story.new(service, username, id: id, price: price, currency: currency, link: link)
      end

      def build_developer(service, username, payload)
        PPT::Developer.new(service, username, id: 'id')
      end
    end
  end
end
