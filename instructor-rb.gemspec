# frozen_string_literal: true

require_relative 'lib/instructor/version'

Gem::Specification.new do |spec|
  spec.name = 'instructor-rb'
  spec.version = Instructor::VERSION
  spec.authors = ['Jason Liu', 'Sergio Bayona']
  spec.email = ['jason@jxnl.co', 'bayona.sergio@gmail.com']

  spec.summary = 'Structured extraction in Ruby, powered by llms.'
  spec.description = "Explore the power of structured extraction in Ruby with the Instructor gem. Leveraging OpenAI's function calling API."
  spec.homepage = 'https://github.com/instructor-ai/instructor-rb'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 2.7.0'

  spec.metadata['allowed_push_host'] = 'https://rubygems.pkg.github.com/instructor-ai'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/instructor-ai/instructor-rb'
  spec.metadata['changelog_uri'] = 'https://github.com/instructor-ai/instructor-rb/blob/main/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[spec/ .git .github Gemfile])
    end
  end

  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport', '~> 7.0'
  spec.add_dependency 'easy_talk', '~> 0.1.7'
  spec.add_dependency 'ruby-openai', '~> 6'
end
