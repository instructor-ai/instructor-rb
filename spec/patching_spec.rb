require 'spec_helper'

RSpec.describe 'patching the OpenAI client' do

  subject(:patched_client) { Instructor.patch(OpenAI::Client) }
  let(:user_model) do
    Class.new(Instructor::Model) do
      def self.name
        'UserDetail'
      end

      params do
        required(:name).filled(:string)
        required(:age).filled(:integer)
      end
    end
  end

  it "returns the patched client" do
    expect(patched_client).to eq(OpenAI::Client)
  end

  context "a new instance of the patched client" do
    it "returns an instance of the patched client" do
      expect(patched_client.new).to be_an_instance_of(OpenAI::Client)
    end

    it "receives the chat method with the expected arguments" do
      client = patched_client.new
      expect(client).to receive(:chat).with(parameters: {}, response_model: nil)
      client.chat(parameters: {}, response_model: nil)
    end

    it "does not require the response model argument" do
      client = patched_client.new
      expect { client.chat(parameters: {}) }.not_to raise_error(ArgumentError)
    end

    it "does require the parameters argument" do
      client = patched_client.new
      expect { client.chat }.to raise_error(ArgumentError, "missing keyword: :parameters")
    end

    # it "returns an object with the expected valid attribute values" do
    #   client = patched_client.new

    #   user = client.chat(
    #     parameters: {
    #       model: 'gpt-3.5-turbo',
    #       messages: [{ role: 'user', content: 'Extract Jason is 25 years old' }]
    #     },
    #     response_model: user_model
    #   )

    #   binding.pry

    #   expect(user[:name]).to eq('Jason')
    #   expect(user[:age]).to eq(25)
    # end
  end
end
