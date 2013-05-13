# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "siriproxy-nest"
  s.version     = "0.0.1" 
  s.authors     = ["cobralibre"]
  s.email       = ["jacobc@gmail.com"]
  s.homepage    = "http://golden.cpl593h.net/"
  s.summary     = %q{Allows a Nest thermostat to be controlled with Siri}
  s.description = %q{This is a Siriproxy plugin that lets you control a Nest thermostat through Siri.}

  s.rubyforge_project = "siriproxy-nest"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  s.add_runtime_dependency "nest_thermostat"
end
