require 'spec_helper'
require_relative '../../lib/instructor/dsl/conditional_require'

# rubocop:disable Metrics/BlockLength
RSpec.describe Instructor::DSL::ConditionalRequire do
  context 'if/then' do
    let(:expected_output) do
      {
        'if' => {
          'properties' => {
            'type' => {
              "const": 'car'
            }
          }
        },
        'then' => {
          "required": %w[
            make
            model
          ]
        }
      }
    end

    let(:vehicle) { described_class.new }

    it 'outputs if/then clause in json-schema' do
      vehicle.if do |condition|
        condition.properties do |attr|
          attr.type 'car'
        end
      end

      vehicle.then do |requirement|
        requirement.required 'make', 'model'
      end

      expect(vehicle.to_json).to eq(expected_output.to_json)
    end
  end

  context 'if/then/else' do
    let(:vehicle) { described_class.new }

    it 'outputs if/then/else clause in json-schema' do
      vehicle.if do |condition|
        condition.properties do |attr|
          attr.type 'car'
        end

        condition.then do |requirement|
          requirement.required 'make', 'model'
        end

        condition.else do |requirement|
          requirement.required 'make'
        end
      end

      binding.pry
      expect(vehicle.to_json).to eq(expected_output.to_json)
    end
  end
end
