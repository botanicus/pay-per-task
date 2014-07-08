require 'ppt/processor'
require 'http'

class PPT
  module PT
    class Processor < PPT::Processor
      def ensure_developer_exists(company_id, payload)
        # There is nothing to update. The user either exists, or he doesn't.
        return if PPT::DB::Developer.get("devs.#{company}:#{username}")

        company = PPT::DB::User.get("users.#{company_id}")

        # We don't get the email posted to us, so we
        # need to use the API in order to retrieve it.
        project_id = payload['project']['id']
        pt_user_id = payload['performed_by']['id']

        developer = fetch_developer(company, project_id, pt_user_id)
        developer.save

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

      protected
      def fetch_developer(company_id, project_id, pt_user_id)
        users = JSON.parse(
          HTTP.with('X-TrackerToken' => company.pt.api_key).
            get("/projects/#{project_id}/memberships").
            body.readpartial
        )

        user = users.find { |user| user['id'] == pt_user_id }['person']

        developer = PPT::DB::Developer.new(
          company: company.id, username: user['username'], name: user['name'], email: user['email']
        )
      end
    end
  end
end
