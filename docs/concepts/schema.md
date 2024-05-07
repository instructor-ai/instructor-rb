# EasyTalk Schemas 

EasyTalk is a Ruby library for describing, generating and validating JSON Schema. 

## Basic Usage

```Ruby

  class UserDetail
    include EasyTalk::Model

    define_schema do
      property :name, String
      property :age, Integer
    end
  end
```

## Descriptions are Prompts

One of the core things about instructors is that it's able to use these descriptions as part of the prompt. 

```Ruby
  class UserDetail
    include EasyTalk::Model

    define_schema do
      description 'Fully extracted user detail'
      property :name, String, description: 'Your full name'
      property :age, Integer
    end
  end
```

## Model Composition

EasyTalk models can themselves be composed of other models.

```Ruby
  class Address
    include EasyTalk::Model

    define_schema do
      property :street, String
      property :city, String
    end
  end

  class UserDetail
    include EasyTalk::Model

    define_schema do
      property :name, String
      property :address, Address
    end
  end

```

## Default Values

In order to help the language model, we can also define defaults for the values.

```Ruby
  class UserDetail
    include EasyTalk::Model

    define_schema do
      property :name, String
      property :is_student, Boolean, default: false
    end
  end

```
## Arrays

Arrays can be defined using the `T::Array[]` method.

```Ruby
  class UserDetail
    include EasyTalk::Model

    define_schema do
      property :name, String
      property :friends, T::Array[String]
    end
  end

```

## Enums 

Enums can be defined using the `enum` constraint.

```Ruby
  class UserDetail
    include EasyTalk::Model

    define_schema do
      property :name, String
      property :role, String, enum: %w[admin user]
    end
  end

```