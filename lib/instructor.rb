# frozen_string_literal: true

require 'openai'
require 'easy_talk'
require 'active_support/all'
require_relative 'instructor/version'
require_relative 'instructor/openai/patch'
require_relative 'instructor/openai/response'

module Instructor
  class Error < ::StandardError; end

  class ValidationError < ::StandardError; end

  # patches the OpenAI client to add the following functionality:
  # - Retries on exceptions
  # - Accepts and validates a response model
  # - Accepts a validation_context argument
  def self.patch(openai_client)
    openai_client.prepend(Instructor::OpenAI::Patch)
  end
end
