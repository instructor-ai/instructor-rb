# instructor-rb

_Structured extraction in Ruby, powered by llms, designed for simplicity, transparency, and control._

---

[![Twitter Follow](https://img.shields.io/twitter/follow/jxnlco?style=social)](https://twitter.com/jxnlco)
[![Documentation](https://img.shields.io/badge/docs-available-brightgreen)](https://jxnl.github.io/instructor-rb)
[![GitHub issues](https://img.shields.io/github/issues/instructor-ai/instructor-js.svg)](https://github.com/instructor-ai/instructor-rb/issues)
[![Discord](https://img.shields.io/discord/1192334452110659664?label=discord)](https://discord.gg/CV8sPM5k5Y)

Dive into the world of Ruby-based structured extraction, by OpenAI's function calling API and ActiveRecord, ruby-first schema validation with type inference. Instructor stands out for its simplicity, transparency, and user-centric design. Whether you're a seasoned developer or just starting out, you'll find Instructor's approach intuitive and steerable.

> ℹ️ **Tip:**  Support in other languages

    Check out ports to other languages below:

    - [Python](https://www.github.com/jxnl/instructor)
    - [TS/JS](https://github.com/instructor-ai/instructor-js/)
    - [Elixir](https://github.com/thmsmlr/instructor_ex/)

    If you want to port Instructor to another language, please reach out to us on [Twitter](https://twitter.com/jxnlco) we'd love to help you get started!

## Usage

```rb
# Todo, change to ruby
import Instructor from "@instructor-ai/instructor";
import OpenAI from "openai"
import { z } from "zod"

const UserSchema = z.object({
  age: z.number(),
  name: z.string()
})

type User = z.infer<typeof UserSchema>

const oai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY ?? undefined,
  organization: process.env.OPENAI_ORG_ID ?? undefined
})

const client = Instructor({
  client: oai,
  mode: "FUNCTIONS" # or "TOOLS" or "MD_JSON" or "JSON"
})

const user = await client.chat.completions.create({
  messages: [{ role: "user", content: "Jason Liu is 30 years old" }],
  model: "gpt-3.5-turbo",
  response_model: { schema: UserSchema }
})

console.log(user)
// { age: 30, name: "Jason Liu" }
```

## Why use Instructor?

The question of using Instructor is fundamentally a question of why to use zod.

1. **Powered by OpenAI** — Instructor is powered by OpenAI's function calling API. This means you can use the same API for both prompting and extraction.

2. **Customizable** — Zod is highly customizable. You can define your own validators, custom error messages, and more.

3. **Ecosystem** Zod is the most widely used data validation library for Typescript.

4. **Battle Tested** — Zod is downloaded over 24M times per month, and supported by a large community of contributors.

## More Examples

If you'd like to see more check out our [cookbook](examples/index.md).

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