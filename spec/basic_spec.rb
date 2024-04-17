# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'running an OpenAI function call' do
  class UserDetail
    include EasyTalk::Model
    define_schema do
      property :name, String
      property :age, Integer
    end
  end

  it 'returns an object with the expected valid attribute values', vcr: 'basic_spec/valid_response' do
    client = Instructor.patch(OpenAI::Client).new

    user = client.chat(
      parameters: {
        model: 'gpt-3.5-turbo',
        messages: [{ role: 'user', content: 'Extract Jason is 25 years old' }]
      },
      response_model: UserDetail
    )

    expect(user.name).to eq('Jason')
    expect(user.age).to eq(25)
  end
end
