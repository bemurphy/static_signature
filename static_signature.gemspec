# -*- encoding: utf-8 -*-
require File.expand_path('../lib/static_signature/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Brendon Murphy"]
  gem.email         = ["xternal1+github@gmail.com"]
  gem.description   = %q{Rack Middleware for adding query string cache busting signatures on
script and style assets}
  gem.summary       = gem.description
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "static_signature"
  gem.require_paths = ["lib"]
  gem.version       = StaticSignature::VERSION

  gem.add_dependency("nokogiri")
  gem.add_development_dependency("rack-test")
end
