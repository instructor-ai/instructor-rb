# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'running an OpenAI function with an interable response model' do
  class UserDetail
    include EasyTalk::Model
    define_schema do
      property :name, String
      property :age, Integer
    end
  end

  it 'returns an object with the expected valid attribute values', vcr: 'iterable_spec/valid_response' do
    client = Instructor.patch(OpenAI::Client).new

    users = client.chat(
      parameters: {
        model: 'gpt-3.5-turbo',
        messages: [
          { role: 'system', content: 'Extract the names and ages of the users' },
          { role: 'user', content: 'Extract `Jason is 25 and Peter is 32`' }
        ]
      },
      response_model: T::Array[UserDetail]
    )

    users.each do |user|
      expect(user.valid?).to eq(true)
      expect(user.name).to be_a(String)
      expect(user.age).to be_a(Integer)
    end

    expect(users[0].name).to eq('Jason')
    expect(users[0].age).to eq(25)
    expect(users[1].name).to eq('Peter')
    expect(users[1].age).to eq(32)
  end
end
