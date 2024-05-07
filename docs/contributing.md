We would love for you to contribute to `Instructor-rb`.

## Migrating Docs from Python

Theres a bunch of examples in the python version, including documentation here [python docs](https://jxnl.github.io/instructor/examples/)

If you want to contribute, please check out [issues](https://github.com/instructor-ai/instructor/issues)

## Issues

If you find a bug, please file an issue on [our issue tracker on GitHub](https://github.com/instructor-ai/instructor-rb/issues).

To help us reproduce the bug, please provide a minimal reproducible example, including a code snippet and the full error message as well as:

1. The `response_model` you are using.
2. The `messages` you are using.
3. The `model` you are using.

---

## Environment Setup

Ruby 3.2.1 is required to run the project.


### Installation

1. **Install Dependencies**:
   Run the following command to install the project dependencies:

```bash
bundle install
```

2. **Environment Variables**:
setup the OpenAI API key in your environment variables.

```bash

### Code Quality Tools

- This project uses rubocop.

### Running Tests

- Execute tests using the following command:

```bash
bundle exec rspec
```

### Running the Rubocop

```bash
bundle exec rubocop
```

### Pull Requests

We welcome pull requests! There is plenty to do, and we are happy to discuss any contributions you would like to make.

If it is not a small change, please start by [filing an issue](https://github.com/instructor-ai/instructor-rb/issues) first.


## Community and Support

- Join our community on Discord: [Join Discord](https://discord.gg/DWHZdqpNgz)
- Reach out on Twitter: [@sergiobayona](https://twitter.com/sergiobayona) [@jxnlco](https://twitter.com/jxnlco)

## Contributors

<a href="https://github.com/jxnl/instructor/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=instructor-ai/instructor-rb" />
</a>


## Additional Resources
Python is required to run the documentation locally using mkdocs.

To improve your understanding of the documentation, here are some useful references:

- **mkdocs serve:** The `mkdocs serve` command is used to preview your documentation locally during the development phase. When you run this command in your terminal, MkDocs starts a development server, allowing you to view and interact with your documentation in a web browser. This is helpful for checking how your changes look before publishing the documentation. Learn more in the [mkdocs serve documentation](https://www.mkdocs.org/commands/serve/).

- **hl_lines in Code Blocks:** The `hl_lines` feature in code blocks allows you to highlight specific lines within the code block. This is useful for drawing attention to particular lines of code when explaining examples or providing instructions. You can specify the lines to highlight using the `hl_lines` option in your code block configuration. For more details and examples, you can refer to the [hl_lines documentation](https://www.mkdocs.org/user-guide/writing-your-docs/#syntax-highlighting).

- **Admonitions:** Admonitions are a way to visually emphasize or call attention to certain pieces of information in your documentation. They come in various styles, such as notes, warnings, tips, etc. Admonitions provide a structured and consistent way to present important content. For usage examples and details on incorporating admonitions into your documentation, you can refer to the [admonitions documentation](https://www.mkdocs.org/user-guide/writing-your-docs/#admonitions).

For more details about the documentation structure and features, refer to the [MkDocs Material documentation](https://squidfunk.github.io/mkdocs-material/).
  
Thank you for your contributions, and happy coding!