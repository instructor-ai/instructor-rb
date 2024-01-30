require 'dry-validation'
require 'dry-types'
require 'dry-struct'

Dry::Schema.load_extensions(:json_schema)
class Instructor::Model < Dry::Validation::Contract
end
