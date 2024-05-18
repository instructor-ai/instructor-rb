# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Instructor, 'tools mode' do
  it 'returns the mode' do
    Instructor.patch(OpenAI::Client, mode: Instructor::Mode::TOOLS.function)
    expect(Instructor.mode).to eq(Instructor::Mode::TOOLS.function)
  end
end
