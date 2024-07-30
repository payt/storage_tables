# frozen_string_literal: true

require_relative "lib/storage_tables/version"

Gem::Specification.new do |spec|
  spec.name        = "storage_tables"
  spec.version     = StorageTables::VERSION
  spec.authors     = ["Bob van Oorschot"]
  spec.email       = ["b.vanoorschot@paytsoftware.com"]
  spec.homepage    = "https://github.com/payt/storage-tables"
  spec.summary     = "Summary of StorageTables."
  spec.description = "Description of StorageTables."
  spec.license     = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 3.2.2")

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/payt/storage-tables/blob/main/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "aws-sdk-s3", "~> 1.48"
  spec.add_dependency "rails", "7.1.3.4"
  spec.metadata["rubygems_mfa_required"] = "true"
end
