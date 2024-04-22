# frozen_string_literal: true

module Instructor
  module OpenAI
    class Response
      def initialize(response)
        @response = response
      end

      def chat_completions
        @response['choices']
      end

      def tool_calls
        chat_completions&.dig(0, 'message', 'tool_calls')
      end

      def function_responses
        tool_calls&.map { |tool_call| tool_call['function'] }
      end

      def function_response
        function_responses&.first
      end

      def single_response?
        function_responses&.size == 1
      end

      def parse
        if single_response?
          JSON.parse(function_response['arguments'])
        else
          function_responses.map { |res| JSON.parse(res['arguments']) }
        end
      end

      def by_function_name(function_name)
        function_responses&.find { |res| res['name'] == function_name }&.dig('arguments')
      end
    end
  end
end
