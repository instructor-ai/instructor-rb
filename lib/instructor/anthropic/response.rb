# frozen_string_literal: true

module Instructor
  module Anthropic
    # The Response class represents the response received from the OpenAI API.
    # It takes the raw response and provides convenience methods to access the chat completions,
    # tool calls, function responses, and parsed arguments.
    class Response
      # Initializes a new instance of the Response class.
      #
      # @param response [Hash] The response received from the OpenAI API.
      def initialize(response)
        @response = response
      end

      # Returns the chat completions from the response.
      #
      # @return [Array] An array of chat completions.
      def content
        @response['content']
      end

      # Returns the tool calls from the chat completions.
      #
      # @return [Hash, nil] The tool calls or nil if not found.
      def tool_calls
        content.is_a?(Array) && content.select { |c| c['type'] == 'tool_use' }
      end

      # Checks if there is only a single function response.
      #
      # @return [Boolean] True if there is only a single function response, false otherwise.
      def single_response?
        tool_calls&.size == 1
      end

      def arguments
        tool_calls.map { |tc| tc['input'] }
      end

      # Parses the function response(s) and returns the parsed arguments.
      #
      # @return [Array, Hash] The parsed arguments.
      def parse
        if single_response?
          arguments.first
        else
          arguments
        end
      end

      # Returns the arguments of the function with the specified name.
      #
      # @param function_name [String] The name of the function.
      # @return [Hash, nil] The arguments of the function or nil if not found.
      def by_function_name(function_name)
        function_responses&.find { |res| res['name'] == function_name }&.dig('arguments')
      end
    end
  end
end
