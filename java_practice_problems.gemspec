lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'java_practice_problems/version'

Gem::Specification.new do |spec|
  spec.name          = "java_practice_problems"
  spec.version       = JavaPracticeProblems::VERSION
  spec.authors       = ["Michael Harris"]
  spec.email         = ["mwharris7@gmail.com"]

  spec.summary       = %q{This application allows the user to navigate a cli and select java practice problems to be displayed}
  spec.description   = %q{Scrapes the website CodingBat and returns information on java practice problems}
  spec.homepage      = "https://github.com/prisonmike7/java_practice_problems/"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "http://mygemserver.com"
    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/prisonmike7/java_practice_problems"
    spec.metadata["changelog_uri"] = "https://github.com/prisonmike7/java_practice_problems"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "pry"
  spec.add_dependency "nokogiri"
end
