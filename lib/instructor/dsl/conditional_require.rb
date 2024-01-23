require 'json'

module Instructor
  module DSL
    class ConditionalRequire
      def initialize
        @structure = {}
      end

      def if(&block)
        @structure["if"] = {}
        yield(Property.new(@structure["if"]))
      end

      def then(&block)
        @structure["then"] = {}
        yield(Requirement.new(@structure["then"]))
      end

      def else(&block)
        @structure["else"] = {}
        yield(Requirement.new(@structure["else"]))
      end

      def to_json(*options)
        @structure.to_json(*options)
      end

      class Property
        def initialize(structure)
          @structure = structure
        end

        def properties(&block)
          @structure["properties"] = {}
          yield(self)
        end

        def method_missing(name, *args, &block)
          @structure["properties"][name.to_s] = {"const" => args.first}
        end
      end

      class Requirement
        def initialize(structure)
          @structure = structure
        end

        def required(*args)
          @structure["required"] = args
        end
      end
    end
  end
end
