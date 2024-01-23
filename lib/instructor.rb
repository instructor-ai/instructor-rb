# frozen_string_literal: true

require "active_model"
require "active_support"
require_relative "instructor/version"
require_relative "instructor/type/array"
require_relative "instructor/model_serializer"
require_relative "instructor/base_model"

module Instructor
  class Error < StandardError; end

  # Register the custom array type with ActiveModel
  ActiveModel::Type.register(:array, Instructor::Type::Array)
end
