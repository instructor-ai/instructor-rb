# Philosophy

The instructor values [simplicity](https://eugeneyan.com/writing/simplicity/) and flexibility in leveraging language models (LLMs). It offers a streamlined approach for structured output, avoiding unnecessary dependencies or complex abstractions. Let [EasyTalk](https://github.com/sergiobayona/easy_talk) do the heavy lifting.

> “Simplicity is a great virtue but it requires hard work to achieve it and education to appreciate it. And to make matters worse: complexity sells better.” — Edsger Dijkstra

## The Bridge to Object-Oriented Programming

`instructor` acts as a bridge converting text-based LLM interactions into a familiar object-oriented format. Its integration with EasyTalk provides type hints, and runtime validation. By treating LLMs as methods returning typed objects, instructor makes [language models backwards compatible with code](https://www.youtube.com/watch?v=yj-wSRJwrrc), making them practical for everyday use while being complex enough for advanced applications.

## The zen of `instructor`

Maintain the flexibility and power of Ruby, without unnecessary constraints.

Begin with a method and a return type hint – simplicity is key. With my experience maintaining a large enterprize framework at my previous job over many years I've learned that the goal of a making a useful framework is minimizing regret, both for the author and hopefully for the user.

1. Define a Schema 
```ruby
class StructuredData
    include EasyTalk::Model
end
```
2. Define properties and methods on your schema.
3. Encapsulate all your LLM logic into a function `#!ruby def extract(a)`
4. Define typed computations against your data with `#!ruby def compute(data: StructuredData)` or call methods on your schema `#!ruby data.compute()`

It should be that simple.

## My Goals

The goal for the library, [documentation](https://instructor-ai.github.io/instructor-rb/), and [blog](https://instructor-ai.github.io/instructor-rb/blog/), is to help you be a better Ruby programmer and as a result a better AI engineer.

- The library is a result of my desire for simplicity.
- The library should help maintain simplicity in your codebase.
- I won't try to write prompts for you,
- I don't try to create indirections or abstractions that make it hard to debug in the future

Please note that the library is designed to be adaptable and open-ended, allowing you to customize and extend its functionality based on your specific requirements. If you have any further questions or ideas hit me up on [twitter](https://twitter.com/jxnlco)

Cheers!
