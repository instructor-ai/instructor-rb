# frozen_string_literal: true

# Custom type for arrays. This is needed because the default ActiveModel gem does not have
# sufficient support for arrays.
#
#
# @example
#   class PhoneNumber < Instructor::BaseModel
#     attribute :number, :string
#   end
#
#   class User < Instructor::BaseModel
#     attribute :phone_numbers, :array, of: PhoneNumber, default: []
#   end
#
#   Instructor::ModelSerializer.new(User).json_schema
#   # => {
#   #      "description": "User model",
#   #      "type": "object",
#   #      "properties": {
#   #        "phone_numbers": {
#   #          "title": "Phone numbers",
#   #          "type": "array",
#   #          "default": [],
#   #          "items": {
#   #            "description": "Phone number model",
#   #            "type": "object",
#   #            "properties": {
#   #              "number": {
#   #                "title": "Number",
#   #                "type": "string"
#   #              }
#   #            }
#   #          }
#   #        }
#   #      }
#   #    }
#
#

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
