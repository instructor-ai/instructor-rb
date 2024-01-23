require 'active_support/all'

module Instructor
  class ModelSerializer
    DATETIME_TYPE_MAPPINGS = {
      ActiveModel::Type::Date => 'date',
      ActiveModel::Type::DateTime => 'date-time',
      ActiveModel::Type::Time => 'time'
    }.freeze

    TYPE_MAPPINGS = {
      ActiveModel::Type::String => 'string',
      ActiveModel::Type::Integer => 'integer',
      ActiveModel::Type::Float => 'number',
      ActiveModel::Type::Decimal => 'number',
      ActiveModel::Type::Boolean => 'boolean',
      ActiveModel::Type::Date => 'string',
      ActiveModel::Type::DateTime => 'string',
      ActiveModel::Type::Time => 'string',
      Instructor::Type::Array => 'array'
    }.freeze

    def initialize(model)
      @model = model
    end

    def json_schema
      JSON.generate(build_schema)
    end

    def build_schema
      {
        description: "#{model.name.underscore.humanize} model",
        type: 'object',
        properties: model_attributes,
        required: required_attributes
      }.compact
    end

    private

    attr_reader :model

    def model_attributes
      model.attribute_names.each_with_object({}) do |attr_name, attributes|
        attribute_type = model.attribute_types[attr_name]
        attributes[attr_name] = build_attribute_hash(attr_name, attribute_type)
      end
    end

    def build_attribute_hash(attr_name, attribute_type)
      attribute_hash = {
        title: attr_name.humanize,
        type: json_type_for(attribute_type.class),
        format: format_for(attribute_type),
        default: default_value_for(attr_name),
        enum: enum_for(attr_name)
      }.compact

      if attribute_type.is_a?(Instructor::Type::Array)
        attribute_hash[:items] = self.class.new(attribute_type.subtype).build_schema
      end

      attribute_hash
    end

    def format_for(attribute_type)
      return unless datetime_format?(attribute_type)

      DATETIME_TYPE_MAPPINGS[attribute_type.class]
    end

    def enum_for(attr_name)
      inclusion_validator = model.validators_on(attr_name).detect do |validator|
        validator.is_a?(ActiveModel::Validations::InclusionValidator)
      end
      inclusion_validator&.options&.[](:in)
    end

    def datetime_format?(attribute_type)
      DATETIME_TYPE_MAPPINGS.keys.include?(attribute_type.class)
    end

    def default_value_for(attr_name)
      model._default_attributes[attr_name].value_before_type_cast
    end

    def default_value?(attr_name)
      !model._default_attributes[attr_name].value_before_type_cast.nil?
    end

    def required_attributes
      attributes = model.attribute_names.select do |attr_name|
        required?(attr_name)
      end

      attributes.empty? ? nil : attributes
    end

    def required?(attr_name)
      model.validators_on(attr_name).any? do |validator|
        validator.is_a?(ActiveModel::Validations::PresenceValidator)
      end
    end

    def json_type_for(type)
      TYPE_MAPPINGS[type] || 'string' # default type
    end
  end
end
