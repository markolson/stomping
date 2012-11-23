# -*- encoding: utf-8 -*-
require File.expand_path('../lib/stomping/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Mark Olson"]
  gem.email         = ["\"theothermarkolson@gmail.com\""]
  gem.description   = %q{Write twitter bots wooooo}
  gem.summary       = %q{TWitter Bot Framework}
  gem.homepage      = "http://github.com/markolson/stomping"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "stomping"
  gem.require_paths = ["lib"]
  gem.version       = Stomping::VERSION

  gem.extensions = ["ext/setup/Rakefile"]

  gem.add_dependency 'twitter', '~> 4.2'
  gem.add_dependency 'sequel'
  gem.add_dependency 'json'
  gem.add_dependency 'parse-cron'
  gem.add_dependency 'oauth'
end
