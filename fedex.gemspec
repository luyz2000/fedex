# frozen_string_literal: true

require_relative "lib/fedex/version"

Gem::Specification.new do |spec|
  spec.name          = "fedex"
  spec.version       = Fedex::VERSION
  spec.authors       = ["Luis"]
  spec.email         = ["luis2000_k999@hotmail.com"]

  spec.summary       = "Write a short summary, because RubyGems requires one."
  spec.description   = "Write a longer description or delete this line."
  spec.homepage      = "http://website.com"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = 'http://website.com'
  spec.metadata["source_code_uri"] = "http://github.com/jazminschroeder/fedex"
  spec.metadata["changelog_uri"] = "http://github.com/jazminschroeder/fedex"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "httparty", "~> 0.13.7"
  spec.add_dependency "nokogiri", ">= 1.5.6"
  spec.add_dependency "pry", '~> 0.14.2'
  spec.add_dependency "pry-byebug"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
