# Patching

Instructor enhances the client functionality with three new arguments for backwards compatibility. This allows use of the enhanced client as usual, with structured output benefits.

- `response_model`: Defines the response type for `chat`.
- `max_retries`: Determines retry attempts for failed `chat` validations.
- `validation_context`: Provides extra context to the validation process.

Instructor-rb only supports the 'tools' mode at the moment. Other modes will be added in the near future.

## Tool Calling

This is the recommended method for OpenAI clients. Since tools is the default and only mode currently supported, there is no `mode:` argument available. It "just works" with the patched client.

