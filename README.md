# instructor-rb

_Structured extraction in Ruby, powered by llms, designed for simplicity, transparency, and control._

---

[![Twitter Follow](https://img.shields.io/twitter/follow/jxnlco?style=social)](https://twitter.com/jxnlco)
[![Twitter Follow](https://img.shields.io/twitter/follow/sbayona?style=social)](https://twitter.com/sbayona)
[![Documentation](https://img.shields.io/badge/docs-available-brightgreen)](https://jxnl.github.io/instructor-rb)
[![GitHub issues](https://img.shields.io/github/issues/instructor-ai/instructor-rb.svg)](https://github.com/instructor-ai/instructor-rb/issues)
[![Discord](https://img.shields.io/discord/1192334452110659664?label=discord)](https://discord.gg/CV8sPM5k5Y)

Dive into the world of Ruby-based structured extraction, by OpenAI's function calling API and ActiveRecord, ruby-first schema validation with type inference. Instructor stands out for its simplicity, transparency, and user-centric design. Whether you're a seasoned developer or just starting out, you'll find Instructor's approach intuitive and steerable.

> ℹ️ **Tip:**  Support in other languages

    Check out ports to other languages below:

    - [Python](https://www.github.com/jxnl/instructor)
    - [TS/JS](https://github.com/instructor-ai/instructor-js/)
    - [Ruby](https://github.com/instructor-ai/instructor-rb)
    - [Elixir](https://github.com/thmsmlr/instructor_ex/)

    If you want to port Instructor to another language, please reach out to us on [Twitter](https://twitter.com/jxnlco) we'd love to help you get started!

## Usage

export your OpenAI API key:

```bash
export OPENAI_API_KEY=sk-...
```

Then use Instructor to extract structured data from text in Ruby:

```ruby
require 'instructor'

class UserDetail
  include EasyTalk::Model

  define_schema do
    property :name, String
    property :age, Integer
  end
end

client = Instructor.patch(OpenAI::Client).new

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