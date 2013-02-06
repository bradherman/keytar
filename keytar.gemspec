# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'redis/version'

Gem::Specification.new do |gem|
  gem.name          = "keytar"
  gem.version       = KeytarVersion::VERSION
  gem.authors       = ["Bradley Herman"]
  gem.email         = ["bradley.t.herman@gmail.com"]
  gem.description   = %q{Handles storing of keys based on namespaces to keep from ever needing the keys function}
  gem.summary       = %q{Handles storing of keys based on namespaces to keep from ever needing the keys function}
  gem.homepage      = ""

  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec"
  gem.add_dependency "redis", "~> 3.0.0"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
