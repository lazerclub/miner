# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "miner/version"

Gem::Specification.new do |s|
  s.name        = "miner"
  s.version     = Miner::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["chrisrhoden"]
  s.email       = ["carhoden@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{A simple minecraft server management interface}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "miner"
  
  s.add_dependency "eventmachine", '~> 0.12.10'
  s.add_dependency "thin", '~> 1.2.7'
  
  s.add_development_dependency 'rspec', '~> 2.0.0'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
