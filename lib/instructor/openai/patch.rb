# frozen_string_literal: true

require 'instructor/base/patch'

# The Instructor module provides functionality for interacting with OpenAI's chat API.
module Instructor
  module OpenAI
    # The `Patch` module provides methods for patching and modifying the OpenAI client behavior.
    module Patch
      include Instructor::Base::Patch

      # Sends a chat request to the API and processes the response.
      #
      # @param parameters [Hash] The parameters for the chat request as expected by the OpenAI client.
      # @param response_model [Class] The response model class.
      # @param max_retries [Integer] The maximum number of retries. Default is 0.
      # @param validation_context [Hash] The validation context for the parameters. Optional.
      # @return [Object] The processed response.
      def chat(parameters:, response_model: nil, max_retries: 0, validation_context: nil)
        return json_post(path: '/chat/completions', parameters:) if response_model.nil?

        with_retries(max_retries, [JSON::ParserError, Instructor::ValidationError, Faraday::ParsingError]) do
          model = determine_model(response_model)
          function = build_function(model)
          parameters = prepare_parameters(parameters, validation_context, function)
          response = json_post(path: '/chat/completions', parameters:)
          process_response(response, model)
        end
      end

      # Builds the function details for the API request.
      #
      # @param model [Class] The response model class.
      # @return [Hash] The function details.
      def build_function(model)
        {
          type: 'function',
          function: {
            name: generate_function_name(model),
            description: generate_description(model),
            parameters: model.json_schema
          }
        }
      end
    end
  end
end
