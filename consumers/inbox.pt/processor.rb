require 'ppt/processor'

class PPT
  module PT
    class Processor < PPT::Processor
      def build_developer(service, username, payload)
        email = payload['...']
        PPT::DB::Developer.new(service: service, username: username, email: email)
      end

      def build_story(service, username, payload)
        PPT::DB::Story.new
      end
    end
  end
end
