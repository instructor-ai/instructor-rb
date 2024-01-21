# frozen_string_literal: true

require "instructor"
require "pry"

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
