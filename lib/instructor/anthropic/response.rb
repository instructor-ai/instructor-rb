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

      # Parses the function response(s) and returns the parsed arguments.
      #
      # @return [Array, Hash] The parsed arguments.
      # @raise [StandardError] if the api response contains an error.
      def parse
        raise StandardError, error_message if error?

        if single_response?
          arguments.first
        else
          arguments
        end
      end

      private

      def content
        @response['content']
      end

      def tool_calls
        content.is_a?(Array) && content.select { |c| c['type'] == 'tool_use' }
      end

      def single_response?
        tool_calls&.size == 1
      end

      def arguments
        tool_calls.map { |tc| tc['input'] }
      end

      def error?
        @response['type'] == 'error'
      end

      def error_message
        "#{@response.dig('error', 'type')} - #{@response.dig('error', 'message')}"
      end
    end
  end
end
