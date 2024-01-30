# frozen_string_literal: true

require 'openai'
require 'active_support/all'
require_relative 'instructor/version'
require_relative 'instructor/model'
require_relative 'instructor/openai/client'
require_relative 'instructor/openai/patch'

module Instructor
  class Error < StandardError; end

  # patches the OpenAI client to add new functionality.
  def self.patch(openai_client)
    openai_client.prepend(Instructor::OpenAI::Patch)
  end
end
