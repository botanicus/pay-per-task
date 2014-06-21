require 'ppt/processor'

class PPT
  module PT
    class Processor < PPT::Processor
      def ensure_developer_exists(company, payload)
        # There is nothing to update. The user either exists, or he doesn't.
        return if PPT::DB::Developer.get("devs:#{company}:#{username}")

        developer = PPT::DB::Developer.create(
          company: company, username: username, name: name, email: email
        )

        self.emit('devs.new', developer.to_json)
      end

      # new -> WIP
      # WIP -> done
      # done -> [accepted | rejected]
      #
      # ACCEPTED -> PERMISSIONS!
      def ensure_story_exists(company, payload)
        id = payload['primary_resources']['id']
        title = self.parse_title(payload['primary_resources']['name'])
        price, currency = self.parse_price(payload['primary_resources']['name'])
        link = payload['primary_resources']['url']
        status = payload['changes'][0]['new_values']['current_state']
        story = PPT::DB::Story.update(
          company: company, id: id, title: title, status: status, price: price, currency: currency, link: link
        )

        if story.accepted? && company.allowed_to_do_qa.include?(payload['performed_by']['id']) && ! story.invoiced
          self.emit('stories.accepted', story.to_json)
        end
      end
    end
  end
end
