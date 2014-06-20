require 'redis'
require 'ppt/presenters'

# TODO: created_at & updated_at.
class PPT
  module DB
    def self.redis
      @redis ||= Redis.new(driver: :hiredis)
    end

    #def self.get_klass(name)
      #{'stories' => self::Story, 'users' => self::User, 'devs' => self::Developer}[name]
    #end

    class Entity
      def self.presenter(klass = nil)
        @presenter ||= klass
      end

      attr_reader :presenter
      def initialize(values)
        @presenter = self.class.presenter.new(values)
      end

      def values
        @presenter.values
      end

      def save
        self.values.each do |key, value|
          p [key, value]
          PPT::DB.redis.hset(self.key, key, value)
        end
      end
    end

    class User < Entity
      presenter PPT::Presenters::User

      def key
        "users.#{@presenter.username}"
      end
    end

    class Developer < Entity
      presenter PPT::Presenters::Developer

      def key
        "devs.#{@presenter.company}.#{@presenter.username}"
      end
    end

    class Story < Entity
      presenter PPT::Presenters::Story

      def key
        "stories.#{@presenter.company}.#{@presenter.id}"
      end
    end
  end
end
