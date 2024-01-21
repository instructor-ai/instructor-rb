# frozen_string_literal: true

module Instructor
  module Type
    class Array < ActiveModel::Type::Value
      attr_reader :subtype

      def initialize(options={})
        super()
        @subtype = options.delete(:of)
      end

      def type
        :array
      end

      def cast(value)
        return [] if value.blank?

        value
      end

      def deserialize(value)
        value
      end

      def serialize(value)
        value
      end
    end
  end
end
