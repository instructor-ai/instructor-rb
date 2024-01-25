OpenAI.configure do |config|
  config.access_token = ENV.fetch('OPENAI_API_KEY')
end

module Instructor
  module OpenAI
    class Client
      def initialize
        @client = ::OpenAI::Client.new do |f|
          f.response :logger, Logger.new($stdout), bodies: true if ENV['OPENAI_LOG'] == 'debug'
        end
      end

      def chat(parameters:, response_model:)
        func = generate_function(response_model)
        params = parameters.merge(tools: [func])
        response = @client.chat(parameters: params)
        function_response = get_parsed_res(response)
        model = response_model.new
        model.call(function_response)
      end

      def generate_function(model)
        {
          type: 'function',
          function: {
            name: model.name.humanize.titleize,
            description: generate_description(model),
            parameters: model.schema.json_schema
          }
        }
      end

      def get_parsed_res(response)
        str = response.dig('choices', 0, 'message', 'tool_calls', 0, 'function', 'arguments')
        JSON.parse(str)
      end

      def generate_description(model)
        "Correctly extracted `#{model.name}` with all the required parameters with correct types"
      end
    end
  end
end
