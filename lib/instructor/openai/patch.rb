# frozen_string_literal: true

module Instructor
  module OpenAI
    module Patch
      def with_retries(max_retries, *exceptions)
        retries = 0
        begin
          yield
        rescue *exceptions => e
          puts "Retrying... (#{retries + 1}/#{max_retries})"
          retries += 1
          retry if retries < max_retries
          raise e
        end
      end

      def chat(parameters:, response_model: nil, max_retries: 0, validation_context: nil)
        with_retries(max_retries, JSON::ParserError, Instructor::ValidationError, Faraday::ParsingError) do
          if response_model.is_a?(Enumerable)
            parameters = parameters.merge(tools: response_model.map { |model| generate_function(model) })
          else
            parameters = parse_validation_context(parameters, validation_context)
            func = generate_function(response_model)
            parameters = parameters.merge(tools: [func])
          end
          response = json_post(path: '/chat/completions', parameters: parameters)

          function_response = Response.new(response).parse
          raise Instructor::ValidationError unless valid_json?(function_response, response_model)

          function_response
        end
      end

      def valid_json?(json, response_model)
        response_model.validate_json(json)
      end

      def parse_validation_context(parameters, validation_context)
        return parameters unless validation_context.is_a?(Hash)

        Array[validation_context].each_with_index do |message, index|
          parameters[:messages][index][:content] = parameters[:messages][index][:content] % message
        end

        parameters
      end

      def generate_function(model)
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
    end
  end
end
