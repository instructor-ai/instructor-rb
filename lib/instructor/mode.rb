# frozen_string_literal: true

require 'ostruct'

module Instructor
  # This module defines constants related to different modes of operation.
  # It provides options for tool behavior, function types, and JSON modes.
  # Currently supported modes are:
  # - tools: select between function, auto, required, and none.
  # more modes will be added in the near future.
  module Mode
    tool_options = %w[function auto required none].index_by(&:itself)
    TOOL_BEHAVIOR = OpenStruct.new(tool_options)

    FUNCTIONS = 'function_call'
    PARALLEL_TOOLS = 'parallel_tool_call'
    TOOLS = TOOL_BEHAVIOR
    JSON = 'json_mode'
    MD_JSON = 'markdown_json_mode'
    JSON_SCHEMA = 'json_schema_mode'
  end
end
