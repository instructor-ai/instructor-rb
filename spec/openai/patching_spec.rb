# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'patching the OpenAI client' do
  subject(:patched_client) { Instructor.patch(OpenAI::Client) }

  let(:user_model) do
    Class.new do
      include EasyTalk::Model

      def self.name
        'User'
      end

      define_schema do
        property :name, String
        property :age, Integer
      end
    end
  end

  it 'returns the patched client' do
    expect(patched_client).to eq(OpenAI::Client)
  end

  context 'a new instance of the patched client' do
    it 'returns an instance of the patched client' do
      expect(patched_client.new).to be_an_instance_of(OpenAI::Client)
    end

    it 'receives the chat method with the expected arguments' do
      client = patched_client.new
      expect(client).to receive(:chat).with(parameters: {}, response_model: nil)
      client.chat(parameters: {}, response_model: nil)
    end

    it 'does not require the response model argument' do
      client = patched_client.new
      expect { client.chat(parameters: {}) }.not_to raise_error(ArgumentError)
    end

    it 'does require the parameters argument' do
      client = patched_client.new
      expect { client.chat }.to raise_error(ArgumentError, 'missing keyword: :parameters')
    end

    it 'returns an object with the expected valid attribute values', vcr: 'patching_spec/valid_response' do
      client = patched_client.new

      user = client.chat(
        parameters: {
          model: 'gpt-3.5-turbo',
          messages: [{ role: 'user', content: 'Extract Jason is 25 years old' }]
        },
        response_model: user_model
      )

      expect(user.name).to eq('Jason')
      expect(user.age).to eq(25)
    end
  end

  context 'with retry mechanism' do
    let(:client) { patched_client.new }
    let(:parameters) { { key: 'value' } }
    let(:max_retries) { 3 }

    before do
      allow(client).to receive(:json_post).and_return('choices' =>
        [{ 'index' => 0,
           'message' =>
           { 'role' => 'assistant',
             'tool_calls' => [{ 'id' => 'call_85vQq30Nt8xU1mly2Y2Y1tL2', 'type' => 'function',
                                'function' => { 'name' => 'User', 'arguments' => '\"bad:json\"' } }] } }])
    end

    it 'retries the chat method when parsing fails' do
      expect(client).to receive(:json_post).exactly(max_retries).times
      expect do
        client.chat(parameters:, response_model: user_model, max_retries:)
      end.to raise_error(JSON::ParserError)
    end
  end

  context 'with validation context' do
    it 'returns an object with the expected valid attribute values', vcr: 'patching_spec/with_validation_context' do
      client = patched_client.new

      user = client.chat(
        parameters: {
          model: 'gpt-3.5-turbo',
          messages: [{ role: 'user', content: 'Answer the question: %<question>s with the text chunk: %<text_chunk>s' }]
        },
        response_model: user_model,
        validation_context: { question: 'What is your name and age?',
                              text_chunk: 'my name is Jason and I turned 25 years old yesterday' }
      )

      expect(user.name).to eq('Jason')
      expect(user.age).to eq(25)
    end
  end

  context 'with an invalid response model' do
    let(:invalid_model) do
      Class.new do
        include EasyTalk::Model

        def self.name
          'InvalidModel'
        end

        define_schema do
          property :name, String
          property :age, String
        end
      end
    end

    it 'raises an error when the response model is invalid', vcr: 'patching_spec/invalid_response' do
      client = patched_client.new

      expect do
        client.chat(
          parameters: {
            model: 'gpt-3.5-turbo',
            messages: [{ role: 'user', content: 'Extract Jason is 25 years old' }]
          },
          response_model: invalid_model
        )
      end.to raise_error(Instructor::ValidationError)
    end
  end
end
