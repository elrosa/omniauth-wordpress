# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "omniauth/wordpress/version"

Gem::Specification.new do |s|
  s.name        = "omniauth-wordpress"
  s.version     = Omniauth::Wordpress::VERSION
  s.authors     = ["Magda Sikorska"]
  s.email       = ["madzia.sikorska@gmail.com"]
  s.homepage    = "https://github.com/elrosa/omniauth-wordpress"
  s.summary     = 'Wordpress strategy for OmniAuth.'
  s.description = 'Wordpress strategy for OmniAuth.'
  s.license     = 'MIT'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency 'omniauth-oauth2', '~> 1.2.0'

  s.add_development_dependency 'rspec', '~> 2.7.0'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'webmock'
  s.add_development_dependency 'rack-test'
end
