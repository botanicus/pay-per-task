require 'ppt/processor'
require 'http'

class PPT
  module PT
    class Processor < PPT::Processor
      def ensure_developer_exists(company, payload)
        # TODO: At the moment we don't update the developer details.
        p [:x, PPT::DB::Developer.get("devs.#{company}:#{username}")]
        return developer if developer = PPT::DB::Developer.get("devs.#{company}:#{username}")
        p [:c, company]

        # We don't get the email posted to us, so we
        # need to use the API in order to retrieve it.
        project_id = payload['project']['id']
        pt_user_id = payload['performed_by']['id']

        developer = fetch_developer(company, project_id, pt_user_id)
        p [:d, developer]
        developer.save

        self.emit('devs.new', developer.to_json)

        developer
      end

      # new -> WIP
      # WIP -> done
      # done -> [accepted | rejected]
      #
      # ACCEPTED -> PERMISSIONS!
      def ensure_story_exists(company, developer, payload)
        primary_resources = payload['primary_resources'][0]
        id = primary_resources['id']
        title, price, currency = self.parse_title(primary_resources['name'])
        link = primary_resources['url']
        status = payload['changes'][0]['new_values']['current_state']
        story = PPT::DB::Story.update(
          # TODO: Map PT statuses to PPT statuses.
          company: company.name, id: id, title: title, status: status, price: price, currency: currency, link: link
        )

        dev = payload['performed_by']['id']
        if story.accepted? && company.allowed_to_do_qa?(dev) && ! story.invoiced
          self.emit('stories.accepted', story.to_json)
        end
      end

      protected
      def fetch_developer(company, project_id, pt_user_id)
        users = JSON.parse(
          HTTP.with('X-TrackerToken' => company.pt.api_key).
            get("/projects/#{project_id}/memberships").
            body.readpartial
        )

        user = users.find { |user| user['id'] == pt_user_id }['person']

        developer = PPT::DB::Developer.new(
          company: company.name, username: user['username'], name: user['name'], email: user['email']
        )
      end
    end
  end
end
