# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "mite/version"

Gem::Specification.new do |s|
  s.name        = "mite-rb"
  s.version     = Mite::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Sebastian Munz"]
  s.email       = ["sebastian@yo.lk"]
  s.homepage    = "https://github.com/yolk/mite-rb"
  s.summary     = %q{The official ruby library for interacting with the RESTful mite.api.}
  s.description = %q{The official ruby library for interacting with the RESTful mite.api.}

  s.rubyforge_project = "mite-rb"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency(%q<activeresource>, [">= 3.1.0"])
end

