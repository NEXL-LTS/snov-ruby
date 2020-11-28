require_relative 'lib/snov/version'

Gem::Specification.new do |spec|
  spec.name          = "snov"
  spec.version       = Snov::VERSION
  spec.authors       = ["Grant Petersen-Speelman"]
  spec.email         = ["grantspeelman@gmail.com"]

  spec.summary       = %q{Snov client to interact with snov api}
  spec.description   = %q{Snov client to interact with snov api}
  spec.homepage      = "https://github.com/NEXL-LTS/snov-ruby"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.4.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/NEXL-LTS/snov-ruby"
  spec.metadata["changelog_uri"] = "https://github.com/NEXL-LTS/snov-ruby/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_dependency 'activemodel'
  spec.add_dependency 'activesupport'
  spec.add_dependency 'faraday'
  spec.add_dependency 'multi_json'
end
