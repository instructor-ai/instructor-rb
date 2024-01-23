require 'json'

module Instructor
  module DSL
    class ConditionalRequire
      def initialize
        @structure = {}
      end

      def if
        @structure['if'] = {}
        yield(Property.new(@structure['if']))
      end

      def then
        @structure['then'] = {}
        yield(Requirement.new(@structure['then']))
      end

      def else
        @structure['else'] = {}
        yield(Requirement.new(@structure['else']))
      end

      def to_json(*options)
        @structure.to_json(*options)
      end

      class Property
        def initialize(structure)
          @structure = structure
        end

        def properties
          @structure['properties'] = {}
          yield(self)
        end

        def method_missing(name, *args)
          @structure['properties'][name.to_s] = { 'const' => args.first }
        end
      end

      class Requirement
        def initialize(structure)
          @structure = structure
        end

        def required(*args)
          @structure['required'] = args
        end
      end
    end
  end
end
