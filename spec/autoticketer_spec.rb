# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Auto-ticketer' do
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

  def generate(data)
    client = Instructor.patch(OpenAI::Client).new

    client.chat(
      parameters: {
        model: 'gpt-3.5-turbo',
        messages: [
          {
            role: 'system',
            "content": 'The following is a transcript of a meeting between a manager and their team. The manager is assigning tasks to their team members and creating action items for them to complete.'
          },
          {
            "role": 'user',
            "content": "Create the action items for the following transcript: #{data}"
          }
        ]
      },
      response_model: ActionItems
    )
  end

  it 'generates the proper json-schema', vcr: 'autoticketer/generate' do
    data = <<~DATA
      Alice: Hey team, we have several critical tasks we need to tackle for the upcoming release. First, we need to work on improving the authentication system. It's a top priority.

      Bob: Got it, Alice. I can take the lead on the authentication improvements. Are there any specific areas you want me to focus on?

      Alice: Good question, Bob. We need both a front-end revamp and back-end optimization. So basically, two sub-tasks.

      Carol: I can help with the front-end part of the authentication system.

      Bob: Great, Carol. I'll handle the back-end optimization then.

      Alice: Perfect. Now, after the authentication system is improved, we have to integrate it with our new billing system. That's a medium priority task.

      Carol: Is the new billing system already in place?

      Alice: No, it's actually another task. So it's a dependency for the integration task. Bob, can you also handle the billing system?

      Bob: Sure, but I'll need to complete the back-end optimization of the authentication system first, so it's dependent on that.

      Alice: Understood. Lastly, we also need to update our user documentation to reflect all these changes. It's a low-priority task but still important.

      Carol: I can take that on once the front-end changes for the authentication system are done. So, it would be dependent on that.

      Alice: Sounds like a plan. Let's get these tasks modeled out and get started.
    DATA
    result = generate(data)

    expect(result).to include_json(
      {
        "items": [
          {
            "id": 1,
            "name": 'Improve Authentication System',
            "description": 'Work on front-end revamp and back-end optimization',
            "priority": 'High',
            "assignees": %w[
              Bob
              Carol
            ],
            "subtasks": [
              {
                "id": 2,
                "name": 'Front-end Revamp'
              },
              {
                "id": 3,
                "name": 'Back-end Optimization'
              }
            ]
          },
          {
            "id": 4,
            "name": 'Integrate Authentication System with New Billing System',
            "description": 'Integrate authentication system with the new billing system',
            "priority": 'Medium',
            "assignees": [
              'Bob'
            ],
            "dependencies": [
              1
            ]
          },
          {
            "id": 5,
            "name": 'Update User Documentation',
            "description": 'Update user documentation to reflect changes',
            "priority": 'Low',
            "assignees": [
              'Carol'
            ],
            "dependencies": [
              2
            ]
          }
        ]
      }
    )
  end
end
