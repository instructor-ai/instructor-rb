require 'ostruct'

module Instructor
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
