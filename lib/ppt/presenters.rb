class PPT
  module Presenters
    class Entity
      EXPECTED_KEYS ||= [].sort

      attr_reader :values

      def initialize(**values)
        unless values.keys.sort == self.class::EXPECTED_KEYS
          raise ArgumentError.new("Expected keys: #{self.class::EXPECTED_KEYS.inspect}, got #{values.keys.sort.inspect}")
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
      EXPECTED_KEYS = [:service, :username, :email, :accounting_email].sort
    end

    class Story < Entity
      # NOTE: Do NOT use ||=, otherwise Entity#EXPECTED_KEYS shall be utilised.
      EXPECTED_KEYS = [:service, :username, :id, :price, :currency, :link].sort
    end

    class Developer < Entity
      EXPECTED_KEYS = [:service, :username, :email, :name].sort
    end
  end
end
