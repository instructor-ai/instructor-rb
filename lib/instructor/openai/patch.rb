# frozen_string_literal: true

module Instructor
  module OpenAI
    module Patch
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

      def chat(parameters:, response_model: nil, max_retries: 0, validation_context: nil)
        with_retries(max_retries, [JSON::ParserError, Instructor::ValidationError, Faraday::ParsingError]) do
          model = determine_model(response_model)
          function = build_function(model)
          parameters = prepare_parameters(parameters, validation_context, function)
          response = json_post(path: '/chat/completions', parameters: parameters)
          process_response(response, model)
        end
      end

      def prepare_parameters(parameters, validation_context, function)
        parameters = apply_validation_context(parameters, validation_context)
        parameters.merge(tools: [function])
      end

      def process_response(response, model)
        parsed_response = Response.new(response).parse
        iterable? ? process_multiple_responses(parsed_response, model) : process_single_response(parsed_response, model)
      end

      def process_multiple_responses(parsed_response, model)
        parsed_response.map do |response|
          instance = model.new(response)
          instance.valid? ? instance : raise(Instructor::ValidationError)
        end
      end

      def process_single_response(parsed_response, model)
        instance = model.new(parsed_response)
        instance.valid? ? instance : raise(Instructor::ValidationError)
      end

      def determine_model(response_model)
        if response_model.is_a?(T::Types::TypedArray)
          @iterable = true
          response_model.type.raw_type
        else
          @iterable = false
          response_model
        end
      end

      def apply_validation_context(parameters, validation_context)
        return parameters unless validation_context.is_a?(Hash)

        Array[validation_context].each_with_index do |message, index|
          parameters[:messages][index][:content] = parameters[:messages][index][:content] % message
        end

        parameters
      end

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

      def generate_description(model)
        "Correctly extracted `#{model.name}` with all the required parameters with correct types"
      end

      def iterable?
        @iterable
      end
    end
  end
end
