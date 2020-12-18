lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "github_commit"

Gem::Specification.new do |gem|
  gem.name          = "github_commit"
  gem.version       = GithubCommit::VERSION
  gem.authors       = ["GOV.UK Dev"]
  gem.email         = ["govuk-dev@digital.cabinet-office.gov.uk"]
  gem.summary       = "Concourse Resource Type classes for GitHub commits"
  gem.description   = "Gem for GitHub commits as a Concourse Resource Type"
  gem.homepage      = "https://github.com/alphagov/github-commit"
  gem.license       = "OGL-UK-3.0"

  gem.files         = `git ls-files -z`.split("\x0")
  gem.executables   = `git ls-files -z -- bin/*`.split("\x0").map { |f| File.basename(f) }
  gem.test_files    = `git ls-files -z -- {spec}/*`.split("\x0")
  gem.require_paths = %w[lib]

  gem.add_runtime_dependency "octokit", "~> 4.2"

  gem.add_development_dependency "brakeman", "~> 4.10"
  gem.add_development_dependency "rspec", "~> 3.0"
  gem.add_development_dependency "rubocop", "~> 0.87"
  gem.add_development_dependency "rubocop-govuk", "~> 3.17"
  gem.add_development_dependency "simplecov", "~> 0.20"
end
