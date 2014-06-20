require 'ppt/extensions'

class PPT
  module Presenters
    class Entity
      EXPECTED_KEYS ||= []

      attr_reader :values

      def initialize(values)
        # Let's consider it safe since this is not user input.
        # It might not be the best idea, but for now, who cares.
        values = PPT.symbolise_keys(values)

        unless values.keys.sort == self.class::EXPECTED_KEYS.sort
          raise ArgumentError.new("Expected keys: #{self.class::EXPECTED_KEYS.inspect}, got #{values.keys.inspect}")
        end

        @values = values
      end

      def method_missing(name, *args, &block)
        if @values.has_key?(name)
          @values[name]
        else
          super(name, *args, &block)
        end
      end

      def respond_to_missing?(name, include_private = false)
        @values.has_key?(name) || super(name, include_private)
      end

      def to_json
        @values.to_json
      end
    end

    # User is either a person or most likely a company.
    #
    # Each user can have only one service, just to make it simple.
    # Besides, not many people use both Jira and Pivotal Tracker.
    class User < Entity
      EXPECTED_KEYS = [:service, :username, :name, :email, :accounting_email]
    end

    class Developer < Entity
      EXPECTED_KEYS = [:company, :username, :name, :email]
    end

    class Story < Entity
      EXPECTED_KEYS = [:company, :id, :price, :currency, :link]
    end
  end
end
