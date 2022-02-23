require_relative 'lib/snov/version'

Gem::Specification.new do |spec|
  spec.name          = "snov"
  spec.version       = Snov::VERSION
  spec.authors       = ["Grant Petersen-Speelman", "Bapu Sethi"]
  spec.email         = ["grantspeelman@gmail.com", "bapu.sethi.03@gmail.com"]
  spec.license       = "MIT"

  spec.summary       = %q{Snov client to interact with snov api}
  spec.description   = %q{Snov client to interact with snov api}
  spec.homepage      = "https://github.com/NEXL-LTS/snov-ruby"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.5.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/NEXL-LTS/snov-ruby"
  spec.metadata["changelog_uri"] = "https://github.com/NEXL-LTS/snov-ruby/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_dependency 'activemodel', '>= 4.1.0', '< 8.0'
  spec.add_dependency 'activesupport', '>= 4.1.0', '< 8.0'
  spec.add_dependency 'camel_snake_struct', '>= 0.1.0', '< 2.0'
  spec.add_dependency 'faraday', '>= 0.10.0', '< 3.0'
  spec.add_dependency 'multi_json', '>= 1.4.0', '< 2.0'
  spec.metadata['rubygems_mfa_required'] = 'true'
end
