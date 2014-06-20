require 'ppt/extensions'

class PPT
  module Presenters
    class Entity
      def self.attributes
        @attributes ||= Hash.new
      end

      def self.attribute(name, options = Hash.new)
        self.attributes[name] = options
      end

      attr_reader :values

      def initialize(values)
        # Let's consider it safe since this is not user input.
        # It might not be the best idea, but for now, who cares.
        values = PPT.symbolise_keys(values)
        expected_keys = self.class.attributes.select { |name, options| options[:required] }.map { |name, _| name }.sort

        unless values.keys.sort == expected_keys
          raise ArgumentError.new("Expected keys: #{expected_keys.inspect}, got #{values.keys.sort.inspect}")
        end

        private_keys = self.class.attributes.select { |name, options| options[:private] }.map { |name, _| name }
        if union = values.keys & private_keys
          raise ArgumentError.new("The following keys are private: #{union.inspect}")
        end

        # Set the defaults.
        self.class.attributes.select { |name, options| options[:default] }.each do |name, block|
          values[name] = self.instance_eval(&block)
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
    require 'securerandom'

    class User < Entity
      attribute :service, required: true
      attribute :username, required: true
      attribute :name, required: true
      attribute :email, required: true
      attribute :accounting_email, default: Proc.new { self.email }
      attribute :auth_key, private: true, default: Proc.new { Securerandom.hex }
    end

    class Developer < Entity
      attribute :company, required: true
      attribute :username, required: true
      attribute :name, required: true
      attribute :email, required: true
    end

    class Story < Entity
      attribute :company, required: true
      attribute :id, required: true
      attribute :title, required: true
      attribute :price, required: true
      attribute :currency, required: true
      attribute :link, required: true
    end
  end
end
