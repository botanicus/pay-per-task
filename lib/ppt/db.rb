require 'redis'

class PPT
  module DB
    def self.redis
      @redis ||= Redis.new
    end

    class Entity
      def initialize(presenter)
        @presenter = presenter
      end

      def values
        @presenter.values
      end

      def save
        self.values.each do |key, value|
          PPT::DB.redis.hset(self.key, key, value)
        end
      end
    end

    class User < Entity
      def key
        "users.#{@presenter.username}"
      end
    end

    class Story < Entity
      def key
        "stories.#{@presenter.service}.#{@presenter.username}.#{@presenter.id}"
      end
    end

    class Developer < Entity
      def key
        "devs.#{@presenter.service}.#{@presenter.username}.#{@presenter.nickname}"
      end
    end
  end
end
