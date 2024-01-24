require 'spec_helper'

RSpec.describe '' do
  class UserDetail < BaseModel
    schema do
      required(:name).filled(:string)
      required(:age).filled(:integer)
    end
  end

  it '' do
    client = Instructor.patch(OpenAI::Client.new)

    user = client.chat(
      parameters: {
        model: 'gpt-3.5-turbo', # Required.
        messages: [{ role: 'user', content: 'Extract Jason is 25 years old' }], # Required.
        temperature: 0.7
      },
      response_model: UserDetail
    )
    # assert isinstance(user, UserDetail)
    # assert user.name == 'Jason'
    # assert user.age == 25
  end
end
