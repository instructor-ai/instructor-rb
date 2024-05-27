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
          tool_choice = resolve_tool_choice(function[:function][:name])
          parameters.merge!(tool_choice:)
          response = json_post(path: '/chat/completions', parameters:)
          process_response(response, model)
        end
      end

      # Processes the API response.
      #
      # @param response [Hash] The API response.
      # @param model [Class] The response model class.
      # @return [Object] The processed response.
      def process_response(response, model)
        parsed_response = Response.new(response).parse
        iterable? ? process_multiple_responses(parsed_response, model) : process_single_response(parsed_response, model)
      end

      private

      def resolve_tool_choice(function_name)
        case Instructor.mode
        when Instructor::Mode::TOOLS.function
          { type: 'function', function: { name: function_name } }
        when Instructor::Mode::TOOLS.auto
          'auto'
        when Instructor::Mode::TOOLS.required
          'required'
        when Instructor::Mode::TOOLS.none
          'none'
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
