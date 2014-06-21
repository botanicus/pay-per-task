require 'simple-orm'
require 'securerandom'

class PPT
  module Presenters
    # User is either a person or most likely a company.
    #
    # Each user can have only one service, just to make it simple.
    # Besides, not many people use both Jira and Pivotal Tracker.

    class User < Entity
      attribute(:service).required
      attribute(:username).required
      attribute(:name).required
      attribute(:email).required
      attribute(:accounting_email).default { self.email }
      attribute(:auth_key).private.default { SecureRandom.hex }

      attribute(:created_at).type(Time).on_create { Time.now.utc.to_i }
      attribute(:updated_at).type(Time).on_update { Time.now.utc.to_i }
    end

    class Developer < Entity
      attribute(:company).required
      attribute(:username).required
      attribute(:name).required
      attribute(:email).required

      attribute(:created_at).type(Time).on_create { Time.now.utc.to_i }
      attribute(:updated_at).type(Time).on_update { Time.now.utc.to_i }
    end

    class Story < Entity
      attribute(:company).required
      attribute(:id).required
      attribute(:title).required
      attribute(:price).required
      attribute(:currency).required
      attribute(:link).required

      attribute(:created_at).type(Time).on_create { Time.now.utc.to_i }
      attribute(:updated_at).type(Time).on_update { Time.now.utc.to_i }
    end
  end


  module DB
    class User < Entity
      presenter PPT::Presenters::User

      def key
        "users.#{self.username}"
      end
    end

    class Developer < Entity
      presenter PPT::Presenters::Developer

      def key
        "devs.#{self.company}.#{self.username}"
      end
    end

    class Story < Entity
      presenter PPT::Presenters::Story

      def key
        "stories.#{self.company}.#{self.id}"
      end
    end
  end
end
