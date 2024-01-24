# frozen_string_literal: true

require 'openai'
require_relative 'instructor/version'
require_relative 'instructor/base_model'

module Instructor
  class Error < StandardError; end

  OpenAI.configure do |config|
    config.access_token = ENV.fetch('OPENAI_API_KEY')
  end

  def patch(options)
    options
  end
end
