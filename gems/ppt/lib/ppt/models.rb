require 'date'
require 'securerandom'

require 'simple-orm'

class PPT
  module Presenters
    # User is either a person or most likely a company.
    #
    # Each user can have only one service, just to make it simple.
    # Besides, not many people use both Jira and Pivotal Tracker.

    class User < SimpleORM::Presenter
      attribute(:service).required
      attribute(:username).required
      attribute(:name).required
      attribute(:email).required
      attribute(:accounting_email) # TODO: Make it return self.email WITHOUT saving it.
      attribute(:auth_key).private.default { SecureRandom.hex }
      attribute(:plan).required#.enum(:free, :small, :large)

      # list(:payments) do
      #   # plan (can change) | paid how much | paid when
      # end

      [:pt, :jira].each do |issue_tracker|
        namespace(issue_tracker) do
          attribute(:api_key)
        end
      end

      attribute(:created_at).
        deserialise { |data| DateTime.parse(data) }.
        on_create { DateTime.now.iso8601 }

      attribute(:updated_at).
        deserialise { |data| DateTime.parse(data) }.
        on_create { DateTime.now.iso8601 } # TODO: Make this on_update only, again, mind the RAM.
    end

    class Developer < SimpleORM::Presenter
      attribute(:company).required
      attribute(:username).required
      attribute(:name).required
      attribute(:email).required

      attribute(:created_at).
        deserialise { |data| DateTime.parse(data) }.
        on_create { DateTime.now.iso8601 }

      attribute(:updated_at).
        deserialise { |data| DateTime.parse(data) }.
        on_create { DateTime.now.iso8601 }
    end

    class Story < SimpleORM::Presenter
      attribute(:company).required
      attribute(:id).required
      attribute(:title).required
      attribute(:price).required
      attribute(:currency).required
      attribute(:link).required
      attribute(:status).required

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
    end

    class Developer < SimpleORM::DB
      presenter PPT::Presenters::Developer
      key 'devs.{company}.{username}'
    end

    class Story < SimpleORM::DB
      presenter PPT::Presenters::Story
      key 'stories.{company}.{id}'
    end
  end
end
