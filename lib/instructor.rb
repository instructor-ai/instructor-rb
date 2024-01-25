# frozen_string_literal: true

require 'openai'
require 'active_support/all'
require_relative 'instructor/version'
require_relative 'instructor/base_model'
require_relative 'instructor/openai/client'

module Instructor
  class Error < StandardError; end

  def self.patch(library)
    library.append(BaseModel)
  end
end
