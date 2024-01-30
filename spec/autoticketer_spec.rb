require 'spec_helper'
require 'dry-types'
require 'dry-struct'

RSpec.describe 'Auto-ticketer' do
  module Types
    include Dry.Types()
  end

  class Subtask < Instructor::Model
    schema do
      required(:id).filled(:integer)
      required(:name).filled(:string)
    end
  end

  class Ticket < Instructor::Model
    PRIORITY = Types::String.enum('low', 'medium', 'high')

    schema do
      required(:id).filled(:integer)
      required(:name).filled(:string)
      required(:description).filled(:string)
      required(:priority).filled(PRIORITY)
      required(:assignees).filled(Types::Array.of(Types::Coercible::String))
      # required(:subtasks).filled(Types::Array.of(Subtask))
    end
  end

  # class ActionItems < Instructor::Model
  #   schema do
  #     required(:items).filled(Types::Array.of(Ticket))
  #   end
  # end

  subject(:client) { Instructor.patch(OpenAI::Client) }

  it "generates the proper json-schema" do

    binding.pry

    expect(ActionItems.schema.json_schema).to eq(
      {
        "type": "object",
        "properties": {
          "items": {
            "type": "array",
            "items": {
              "type": "object",
              "properties": {
                "id": {
                  "type": "integer"
                },
                "name": {
                  "type": "string"
                },
                "description": {
                  "type": "string"
                },
                "priority": {
                  "type": "string",
                  "enum": [
                    "low",
                    "medium",
                    "high"
                  ]
                },
                "assignees": {
                  "type": "array",
                  "items": {
                    "type": "string"
                  }
                },
                "subtasks": {
                  "type": "array",
                  "items": {
                    "type": "object",
                    "properties": {
                      "id": {
                        "type": "integer"
                      },
                      "name": {
                        "type": "string"
                      }
                    },
                    "required": [
                      "id",
                      "name"
                    ]
                  }
                }
              },
              "required": [
                "id",
                "name",
                "description",
                "priority",
                "assignees",
                "subtasks"
              ]
            }
          }
        },
        "required": [
          "items"
        ]
      }
    )
  end

  # it "returns the patched client" do

  #   user = client.chat(
  #     parameters: {
  #       model: 'gpt-3.5-turbo',
  #       messages: [{ role: 'user', content: 'Extract Jason is 25 years old' }]
  #     },
  #     response_model: ActionItems
  #   )
  # end
end
