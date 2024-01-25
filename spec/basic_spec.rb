require 'spec_helper'

RSpec.describe 'running an OpenAI function call' do
  class UserDetail < Instructor::Model
    params do
      required(:name).filled(:string)
      required(:age).filled(:integer)
    end
  end

  it 'returns an object with the expected valid attribute values' do
    client = Instructor::OpenAI::Client.new

    user = client.chat(
      parameters: {
        model: 'gpt-3.5-turbo',
        messages: [{ role: 'user', content: 'Extract Jason is 25 years old' }]
      },
      response_model: UserDetail
    )

    expect(user[:name]).to eq('Jason')
    expect(user[:age]).to eq(25)
  end
end
