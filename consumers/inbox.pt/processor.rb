require 'ppt/processor'

class PPT
  module PT
    class Processor < PPT::Processor
      def build_developer(service, username, payload)
        email = payload['...']
        PPT::DB::Developer.new(company: company, username: username, name: name, email: email)
      end

      def build_story(service, username, payload)
        PPT::DB::Story.new(company: company, id: id, price: price, currency: currency, link: link)
      end
    end
  end
end
