require "spec_helper"

class PhoneNumber < Instructor::BaseModel
  attribute :number, :string
  attribute :type, :string

  validates :type, inclusion: { in: %w[home work mobile] }
end

class User < Instructor::BaseModel
  attribute :name, :string
  attribute :age, :integer
  attribute :subscribed, :boolean, default: false
  attribute :created_at, :datetime
  attribute :gender, :string
  attribute :phone_numbers, :array, of: PhoneNumber, default: []

  validates :name, :age, presence: true
  validates :gender, inclusion: { in: %w[male female other] }
end

RSpec.describe "json-schema serialization" do
  subject(:user_detail) { Instructor::ModelSerializer.new(User).json_schema }

  let(:user_schema) do
    {
      "description": "User model",
      "type": "object",
      "properties": {
        "name": {
          "title": "Name",
          "type": "string"
        },
        "age": {
          "title": "Age",
          "type": "integer"
        },
        "subscribed": {
          "title": "Subscribed",
          "type": "boolean",
          "default": false
        },
        "created_at": {
          "title": "Created at",
          "type": "string",
          "format": "date-time"
        },
        "gender": {
          "title": "Gender",
          "type": "string",
          "enum": %w[
            male
            female
            other
          ]
        },
        "phone_numbers": {
          "title": "Phone numbers",
          "type": "array",
          "default": [],
          "items": {
            "description": "Phone number model",
            "type": "object",
            "properties": {
              "number": {
                "title": "Number",
                "type": "string"
              },
              "type": {
                "title": "Type",
                "type": "string",
                "enum": %w[
                  home
                  work
                  mobile
                ]
              }
            }
          }
        }
      },
      "required": %w[
        name
        age
      ]
    }
  end

  it "converts to json schema" do
    binding.pry
    expect(user_detail).to eq(JSON.generate(user_schema))
  end
end
