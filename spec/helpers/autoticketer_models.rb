# frozen_string_literal: true

module AutoticketerModels
  class Subtask
    include EasyTalk::Model

    define_schema do
      property :id, Integer, description: 'Unique identifier for the subtask'
      property :name, String, description: 'Informative title of the subtask'
    end
  end

  class Ticket
    include EasyTalk::Model

    PRIORITY = %w[low medium high].freeze

    define_schema do
      property :id, Integer, description: 'Unique identifier for the ticket'
      property :name, String, description: 'Title of the ticket'
      property :description, String, description: 'Detailed description of the ticket'
      property :priority, String, description: 'Priority level'
      property :assignees, T::Array[String], description: 'List of users assigned to the ticket'
      property :subtasks, T.nilable(T::Array[Subtask]), description: 'List of subtasks associated with the ticket'
      property :dependencies, T.nilable(T::Array[Integer]),
               description: 'List of ticket IDs that this ticket depends on'
    end
  end

  class ActionItems
    include EasyTalk::Model

    define_schema do
      property :items, T::Array[Ticket]
    end
  end
end
