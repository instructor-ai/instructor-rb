require 'dry-validation'

Dry::Schema.load_extensions(:json_schema)
class Instructor::Model < Dry::Validation::Contract
end
