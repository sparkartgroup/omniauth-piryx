# -*- encoding: utf-8 -*-
require File.expand_path(File.join('..', 'lib', 'omniauth', 'piryx', 'version'), __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "omniauth-piryx"
  gem.version       = OmniAuth::Piryx::VERSION
  gem.license       = 'MIT'
  gem.summary       = %q{Piryx OAuth2 strategy for OmniAuth 1.x}
  gem.description   = %q{Piryx OAuth2 strategy for OmniAuth 1.x}
  gem.authors       = ["Sparkart"]
  gem.email         = ["product@sparkart.com"]
  gem.homepage      = "https://github.com/SparkartGroupInc/omniauth-piryx"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {spec}/*`.split("\n")
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency 'omniauth', '>= 1.1.1'
  gem.add_runtime_dependency 'omniauth-oauth2', '>= 1.1.1'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec', '~> 2.7'
end