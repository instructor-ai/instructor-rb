# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Instructor, '.class' do
  it 'returns the default mode after patching' do
    described_class.from_openai(OpenAI::Client)
    expect(described_class.mode).to eq(Instructor::Mode::TOOLS.function)
  end

  it 'changes the the mode' do
    described_class.from_openai(OpenAI::Client, mode: Instructor::Mode::TOOLS.auto)
    expect(described_class.mode).to eq(Instructor::Mode::TOOLS.auto)
  end
end
