require 'dry-validation'

Dry::Schema.load_extensions(:json_schema)
class BaseModel < Dry::Validation::Contract
end
