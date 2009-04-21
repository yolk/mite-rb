# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{mite-rb}
  s.version = "0.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Sebastian Munz"]
  s.date = %q{2009-04-21}
  s.description = %q{The official ruby library for interacting with the RESTful mite.api.}
  s.email = %q{sebastian@yo.lk}
  s.extra_rdoc_files = [
    "LICENSE",
    "README.textile"
  ]
  s.files = [
    "CHANGES.txt",
    "LICENSE",
    "README.textile",
    "Rakefile",
    "VERSION.yml",
    "lib/mite-rb.rb",
    "lib/mite/customer.rb",
    "lib/mite/project.rb",
    "lib/mite/service.rb",
    "lib/mite/time_entry.rb",
    "lib/mite/time_entry_group.rb",
    "lib/mite/tracker.rb",
    "lib/mite/user.rb"
  ]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/yolk/mite-rb}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{The official ruby library for interacting with the RESTful API of mite, a sleek time tracking webapp.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>, [">= 2.3.2"])
      s.add_runtime_dependency(%q<activeresource>, [">= 2.3.2"])
    else
      s.add_dependency(%q<activesupport>, [">= 2.3.2"])
      s.add_dependency(%q<activeresource>, [">= 2.3.2"])
    end
  else
    s.add_dependency(%q<activesupport>, [">= 2.3.2"])
    s.add_dependency(%q<activeresource>, [">= 2.3.2"])
  end
end
