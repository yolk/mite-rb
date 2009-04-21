Gem::Specification.new do |s|
  s.name = "mite-rb"
  s.version = "0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  
  s.authors = ["Sebastian Munz"]
  s.date = %q{2009-01-30}
  s.description = "The official ruby library for interacting with the RESTful API of mite, a sleek time tracking webapp."
  s.email = ["team@yo.lk"]
  s.extra_rdoc_files = ["LICENSE"]
  s.files = ["LICENSE", "README.textile", "lib/mite-rb.rb", "lib/mite-rb/console.rb"]
  s.has_rdoc = true
  s.homepage = "http://mite.yo.lk/api"
  s.rdoc_options = ["--main", "README.textile"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.2.0}
  s.summary = "The official ruby library for interacting with the RESTful mite.api."
  s.test_files = []

  s.add_dependency(%q<activesupport>, [">= 2.1.0"])
  s.add_dependency(%q<activeresource>, [">= 2.1.0"])
  
end
