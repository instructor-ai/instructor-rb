module Instructor
  module OpenAI
    module Patch
      def chat(parameters:, response_model: nil)
        if response_model.is_a?(Enumerable)
          params = parameters.merge(tools: response_model.map { |model| generate_function(model) })
        else
          func = generate_function(response_model)
          params = parameters.merge(tools: [func])
        end
        response = super(parameters: params)
        function_response = get_parsed_res(response)
      end

      def get_parsed_res(response)
        str = response.dig('choices', 0, 'message', 'tool_calls', 0, 'function', 'arguments')
        JSON.parse(str)
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

      def generate_description(model)
        "Correctly extracted `#{model.name}` with all the required parameters with correct types"
      end
    end
  end
end
