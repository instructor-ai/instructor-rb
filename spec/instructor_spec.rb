# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Instructor, '.class' do
  it 'returns the mode' do
    described_class.patch(OpenAI::Client, mode: Instructor::Mode::TOOLS.function)
    expect(described_class.mode).to eq(Instructor::Mode::TOOLS.function)
  end
end
