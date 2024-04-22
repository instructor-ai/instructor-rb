# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Instructor::OpenAI::Response do
  subject(:response_object) { described_class.new(response) }

  let(:response) do
    { 'id' => 'chatcmpl-9DEGpBfHqcS17uJtx1vxpRMEb4DtK',
      'object' => 'chat.completion',
      'created' => 1_712_940_147,
      'model' => 'gpt-3.5-turbo-0125',
      'choices' => [
        { 'index' => 0,
          'message' =>
        { 'role' => 'assistant',
          'content' => nil,
          'tool_calls' => [
            {
              'id' => 'call_ljjAxRNujNWmDhrlJW2DLprK',
              'type' => 'function',
              'function' => { 'name' => 'User', 'arguments' => '{"name": "Jason", "age": 25}' }
            }
          ] },
          'logprobs' => nil,
          'finish_reason' => 'tool_calls' }
      ],
      'usage' => {
        'prompt_tokens' => 63,
        'completion_tokens' => 32,
        'total_tokens' => 95
      },
      'system_fingerprint' => 'fp_c2295e73ad' }
  end

  it 'returns a chat completion' do
    expect(response_object.chat_completions).to eq(response['choices'])
  end

  it 'returns the tool calls' do
    expect(response_object.tool_calls).to eq(response['choices'][0]['message']['tool_calls'])
  end

  it 'returns the function responses' do
    expect(response_object.function_responses).to eq([response['choices'][0]['message']['tool_calls'][0]['function']])
  end

  it 'returns the function arguments by function name' do
    expect(response_object.by_function_name('User')).to eq('{"name": "Jason", "age": 25}')
  end

  it 'single response' do
    expect(response_object.single_response?).to eq(true)
  end

  it 'parses the response' do
    expect(response_object.parse).to eq('name' => 'Jason', 'age' => 25)
  end

  it 'returns the first function response' do
    expect(response_object.function_response).to eq(response['choices'][0]['message']['tool_calls'][0]['function'])
  end
end
