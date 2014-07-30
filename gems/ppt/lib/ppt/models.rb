require 'date'
require 'securerandom'

require 'simple-orm'

# TODO: Use timestamp:timezone format, since it's more RAM-efficient.
class PPT
  module Presenters
    # User is either a person or most likely a company.
    #
    # Each user can have only one service, just to make it simple.
    # Besides, not many people use both Jira and Pivotal Tracker.

    class User < SimpleORM::Presenter
      attribute(:username).required
      attribute(:name).required
      attribute(:email).required
      attribute(:accounting_email).value { self.email }
      attribute(:auth_key).private.default { SecureRandom.hex }
      attribute(:plan).required#.enum(:free, :small, :large)

      # list(:payments) do
      #   # plan (can change) | paid how much | paid when
      # end

      attribute(:service_type).required#.enum(:pt, :jira)
      attribute(:service_api_key).required

      attribute(:created_at).
        deserialise { |data| DateTime.parse(data) }.
        on_create { DateTime.now.iso8601 }

      attribute(:updated_at).
        deserialise { |data| DateTime.parse(data) }.
        on_create { DateTime.now.iso8601 } # TODO: Make this on_update only, again, mind the RAM.
    end

    class Developer < SimpleORM::Presenter
      # Key attributes.
      attribute(:company).required
      attribute(:id).required

      attribute(:username).required
      attribute(:name).required
      attribute(:email).required

      namespace(:service) do
        attribute(:type).required#.enum(:pt, :jira)
        attribute(:id).required
      end

      attribute(:created_at).
        deserialise { |data| DateTime.parse(data) }.
        on_create { DateTime.now.iso8601 }

      attribute(:updated_at).
        deserialise { |data| DateTime.parse(data) }.
        on_create { DateTime.now.iso8601 }
    end

    class Story < SimpleORM::Presenter
      # Key attributes.
      attribute(:company).required
      attribute(:id).required

      attribute(:title).required
      attribute(:price).required
      attribute(:currency).required
      attribute(:link).required
      attribute(:status).required#.enum(nil, :wip, :finished, :QAd, :rejected)

      attribute(:created_at).
        deserialise { |data| DateTime.parse(data) }.
        on_create { DateTime.now.iso8601 }

      attribute(:updated_at).
        deserialise { |data| DateTime.parse(data) }.
        on_create { DateTime.now.iso8601 }
    end
  end


  module DB
    class User < SimpleORM::DB
      presenter PPT::Presenters::User

      key 'users.{username}'

      def allowed_to_do_qa?(dev) # Dev is actually inaccurate, it's issue tracker user.
      end
    end

    class Developer < SimpleORM::DB
      presenter PPT::Presenters::Developer

      # Now this is a little bit tricky, we need to be
      # able to find a user by either his username or
      # by the combination of service type and id for
      # usage from within the consumers.
      #
      # We have basically two options:
      #
      # 1) Creating a conversion table
      #    DB::Developer.get("users.#{redis.get('pt.2223')}")
      # 2) Or we put everything into the key:
      #    At the beginning we'd have 'devs.ppt.botanicus.pt.'
      #    Notice the trailing dot.
      #
      #    key = redis.keys("devs.ppt.botanicus.*").first
      #    redis.hgetall(key)
      #
      #    key = redis.keys("devs.ppt.*.pt.2223").first
      #    redis.hgetall(key)
      #
      # PROBLEMS:
      # renaming like when we get to know the service.id :/
      #
      # The second option sounds easier, we can always use '*'
      #
      key 'devs.{company}.{username}.{service.type}.{service.id}'
    end

    class Story < SimpleORM::DB
      presenter PPT::Presenters::Story
      key 'stories.{company}.{id}'

      def accepted?
        self.status == :QAd
      end
    end
  end
end
