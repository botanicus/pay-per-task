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

    class User < Entity
      EXPECTED_KEYS = [:service, :username, :email, :accounting_email]
    end

    class Story < Entity
      EXPECTED_KEYS = [:service, :username, :id, :price, :currency, :link]
    end

    class Developer < Entity
      EXPECTED_KEYS = [:service, :username, :email, :name]
    end
  end
end
