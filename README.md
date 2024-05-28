# instructor-rb

_Structured extraction in Ruby, powered by llms, designed for simplicity, transparency, and control._

---

[![Twitter Follow](https://img.shields.io/twitter/follow/jxnlco?style=social)](https://twitter.com/jxnlco)
[![Twitter Follow](https://img.shields.io/twitter/follow/sbayona?style=social)](https://twitter.com/sbayona)
[![Documentation](https://img.shields.io/badge/docs-available-brightgreen)](https://jxnl.github.io/instructor-rb)
[![GitHub issues](https://img.shields.io/github/issues/instructor-ai/instructor-rb.svg)](https://github.com/instructor-ai/instructor-rb/issues)
[![Discord](https://img.shields.io/discord/1192334452110659664?label=discord)](https://discord.gg/CV8sPM5k5Y)

Instructor-rb is a Ruby library that makes it a breeze to work with structured outputs from large language models (LLMs). Built on top of [EasyTalk](https://github.com/sergiobayona/easy_talk), it provides a simple, transparent, and user-friendly API to manage validation, retries, and streaming responses. Get ready to supercharge your LLM workflows!

# Getting Started

  1. Install Instructor-rb at the command prompt if you haven't yet:
  
        ```bash
        $ gem install instructor-rb
        ```

  2. In your Ruby project, require the gem:

        ```ruby
        require 'instructor'
        ```

  3. At the beginning of your script, initialize and patch the client:

      For the OpenAI client:

        ```ruby
        client = Instructor.from_openai(OpenAI::Client)
        ```
      For the Anthropic client:

        ```ruby
        client = Instructor.from_anthropic(Anthropic::Client)
        ```

## Usage

export your API key:

```bash
export OPENAI_API_KEY=sk-...
```

or for Anthropic:

```bash
export ANTHROPIC_API_KEY=sk-...
```

Then use Instructor by defining your schema in Ruby using the `define_schema` block and [EasyTalk](https://github.com/sergiobayona/easy_talk)'s schema definition syntax. Here's an example in:

```ruby
require 'instructor'

class UserDetail
  include EasyTalk::Model

  define_schema do
    property :name, String
    property :age, Integer
  end
end

client = Instructor.from_openai(OpenAI::Client).new

user = client.chat(
  parameters: {
    model: 'gpt-3.5-turbo',
    messages: [{ role: 'user', content: 'Extract Jason is 25 years old' }]
  },
  response_model: UserDetail
)

user.name
# => "Jason"
user.age
# => 25

```

  
> ℹ️ **Tip:**  Support in other languages

    Check out ports to other languages below:

    - [Python](https://www.github.com/jxnl/instructor)
    - [TS/JS](https://github.com/instructor-ai/instructor-js/)
    - [Ruby](https://github.com/instructor-ai/instructor-rb)
    - [Elixir](https://github.com/thmsmlr/instructor_ex/)

    If you want to port Instructor to another language, please reach out to us on [Twitter](https://twitter.com/jxnlco) we'd love to help you get started!

## Why use Instructor?


1. **OpenAI Integration** — Integrates seamlessly with OpenAI's API, facilitating efficient data management and manipulation.

2. **Customizable** — It offers significant flexibility. Users can tailor validation processes and define unique error messages.

3. **Tested and Trusted** — Its reliability is proven by extensive real-world application.

[Installing Instructor](installation.md) is a breeze. 

## Contributing

If you want to help out, checkout some of the issues marked as `good-first-issue` or `help-wanted`. Found [here](https://github.com/instructor-ai/instructor-js/labels/good%20first%20issue). They could be anything from code improvements, a guest blog post, or a new cook book.

Checkout the [contribution guide]() for details on how to set things up, testing, changesets and guidelines.

## License

This project is licensed under the terms of the MIT License.

## TODO
- [ ] Add patch
  - [ ] Mode.FUNCTIONS
  - [ ] Mode.TOOLS
  - [ ] Mode.MD_JSON
  - [ ] Mode.JSON
- [ ] Add response_model
- [ ] Support async
- [ ] Support stream=True, Partial[T] and iterable[T]
- [ ] Support Streaming
- [ ] Optional/Maybe types
- [ ] Add Tutorials, include in docs
    - [ ] Text Classification
    - [ ] Search Queries
    - [ ] Query Decomposition
    - [ ] Citations
    - [ ] Knowledge Graph
    - [ ] Self Critique
    - [ ] Image Extracting Tables
    - [ ] Moderation
    - [ ] Entity Resolution
    - [ ] Action Item and Dependency Mapping
- [ ] Logging for Distillation / Finetuning
- [ ] Add `llm_validator`