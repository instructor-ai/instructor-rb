# frozen_string_literal: true

# The Instructor module provides functionality for interacting with OpenAI's chat API.
module Instructor
  module OpenAI
    # The `Patch` module provides methods for patching and modifying the OpenAI client behavior.
    module Patch
      # Executes a block of code with retries in case of specific exceptions.
      #
      # @param max_retries [Integer] The maximum number of retries.
      # @param exceptions [Array<Class>] The exceptions to catch and retry.
      # @yield The block of code to execute.
      def with_retries(max_retries, exceptions, &block)
        attempts = 0
        begin
          block.call
        rescue *exceptions
          attempts += 1
          retry if attempts < max_retries
          raise
        end
      end

      # Sends a chat request to the API and processes the response.
      #
      # @param parameters [Hash] The parameters for the chat request as expected by the OpenAI client.
      # @param response_model [Class] The response model class.
      # @param max_retries [Integer] The maximum number of retries. Default is 0.
      # @param validation_context [Hash] The validation context for the parameters. Optional.
      # @return [Object] The processed response.
      def chat(parameters:, response_model: nil, max_retries: 0, validation_context: nil)
        with_retries(max_retries, [JSON::ParserError, Instructor::ValidationError, Faraday::ParsingError]) do
          model = determine_model(response_model)
          function = build_function(model)
          parameters = prepare_parameters(parameters, validation_context, function)
          response = json_post(path: '/chat/completions', parameters:)
          process_response(response, model)
        end
      end

      # Prepares the parameters for the chat request.
      #
      # @param parameters [Hash] The original parameters.
      # @param validation_context [Hash] The validation context for the parameters.
      # @param function [Hash] The function details.
      # @return [Hash] The prepared parameters.
      def prepare_parameters(parameters, validation_context, function)
        parameters = apply_validation_context(parameters, validation_context)
        parameters.merge(tools: [function])
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

      # Processes multiple responses from the API.
      #
      # @param parsed_response [Array<Hash>] The parsed API responses.
      # @param model [Class] The response model class.
      # @return [Array<Object>] The processed responses.
      def process_multiple_responses(parsed_response, model)
        parsed_response.map do |response|
          instance = model.new(response)
          instance.valid? ? instance : raise(Instructor::ValidationError)
        end
      end

      # Processes a single response from the API.
      #
      # @param parsed_response [Hash] The parsed API response.
      # @param model [Class] The response model class.
      # @return [Object] The processed response.
      def process_single_response(parsed_response, model)
        instance = model.new(parsed_response)
        instance.valid? ? instance : raise(Instructor::ValidationError)
      end

      # Determines the response model based on the provided value.
      #
      # @param response_model [Class] The response model class or typed array.
      # @return [Class] The determined response model class.
      def determine_model(response_model)
        if response_model.is_a?(T::Types::TypedArray)
          @iterable = true
          response_model.type.raw_type
        else
          @iterable = false
          response_model
        end
      end

      # Applies the validation context to the parameters.
      #
      # @param parameters [Hash] The original parameters.
      # @param validation_context [Hash] The validation context.
      # @return [Hash] The parameters with applied validation context.
      def apply_validation_context(parameters, validation_context)
        return parameters unless validation_context.is_a?(Hash)

        Array[validation_context].each_with_index do |message, index|
          parameters[:messages][index][:content] = parameters[:messages][index][:content] % message
        end

        parameters
      end

      # Builds the function details for the API request.
      #
      # @param model [Class] The response model class.
      # @return [Hash] The function details.
      def build_function(model)
        {
          type: 'function',
          function: {
            name: model.name.humanize.titleize,
            description: generate_description(model),
            parameters: model.json_schema
          }
        }
      end

      # Generates the description for the function.
      #
      # @param model [Class] The response model class.
      # @return [String] The generated description.
      def generate_description(model)
        "Correctly extracted `#{model.name}` with all the required parameters with correct types"
      end

      # Checks if the response is iterable.
      #
      # @return [Boolean] `true` if the response is iterable, `false` otherwise.
      def iterable?
        @iterable
      end
    end
  end
end
