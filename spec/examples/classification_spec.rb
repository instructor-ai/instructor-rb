require 'spec_helper'

RSpec.describe 'Classification' do
  let(:client) { Instructor.patch(OpenAI::Client).new }

  let(:single_prediction) do
    Class.new do
      include EasyTalk::Model

      def self.name
        'SinglePrediction'
      end

      LABELS = %W[SPAM NOT_SPAM].freeze

      define_schema do
        property :label, String, enum: LABELS, description: 'The predicted label'
        property :confidence, Float, description: 'The confidence score of the prediction'
      end
    end
  end

    let(:parameters) do
      {
        model: 'gpt-3.5-turbo',
        messages: [
          {
            role: 'user',
            content: 'Classify the following text: %<text>s'
          }
        ]
      }
    end

    let(:classifier) do
      client.chat(
        parameters: parameters,
        response_model: user_model,
        validation_context: { question: 'What is your name and age?',
                              text_chunk: 'my name is Jason and I turned 25 years old yesterday' }
      )
    end

end
