# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{punchcard}
  s.version = "0.1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Christoph Olszowka"]
  s.date = %q{2010-12-08}
  s.description = %q{Simple sinatra/mongodb app for tracking time when people have been in the office}
  s.email = %q{christoph at olszowka de}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "Gemfile",
     "Gemfile.lock",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "config.ru",
     "lib/public/cardbg.png",
     "lib/public/css/blueprint.css",
     "lib/public/js/app.js",
     "lib/punchcard.rb",
     "lib/punchcard/mongohq.rb",
     "lib/punchcard/person.rb",
     "lib/punchcard/punch.rb",
     "lib/views/index.haml",
     "lib/views/layout.haml",
     "lib/views/screen.sass",
     "punchcard.gemspec",
     "test/helper.rb",
     "test/test_database.rb",
     "test/test_punchcard.rb"
  ]
  s.homepage = %q{http://github.com/colszowka/punchcard}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Simple sinatra/mongodb app for tracking time when people have been in the office}
  s.test_files = [
    "test/helper.rb",
     "test/test_database.rb",
     "test/test_punchcard.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<sinatra>, [">= 1.0.0"])
      s.add_runtime_dependency(%q<bson_ext>, [">= 0"])
      s.add_runtime_dependency(%q<haml>, [">= 3.0.24"])
      s.add_runtime_dependency(%q<sass>, [">= 3.0.0"])
      s.add_runtime_dependency(%q<mongoid>, [">= 0"])
      s.add_runtime_dependency(%q<gravtastic>, [">= 0"])
      s.add_development_dependency(%q<shoulda>, ["= 2.10.3"])
      s.add_development_dependency(%q<rack-test>, [">= 0.5.6"])
    else
      s.add_dependency(%q<sinatra>, [">= 1.0.0"])
      s.add_dependency(%q<bson_ext>, [">= 0"])
      s.add_dependency(%q<haml>, [">= 3.0.24"])
      s.add_dependency(%q<sass>, [">= 3.0.0"])
      s.add_dependency(%q<mongoid>, [">= 0"])
      s.add_dependency(%q<gravtastic>, [">= 0"])
      s.add_dependency(%q<shoulda>, ["= 2.10.3"])
      s.add_dependency(%q<rack-test>, [">= 0.5.6"])
    end
  else
    s.add_dependency(%q<sinatra>, [">= 1.0.0"])
    s.add_dependency(%q<bson_ext>, [">= 0"])
    s.add_dependency(%q<haml>, [">= 3.0.24"])
    s.add_dependency(%q<sass>, [">= 3.0.0"])
    s.add_dependency(%q<mongoid>, [">= 0"])
    s.add_dependency(%q<gravtastic>, [">= 0"])
    s.add_dependency(%q<shoulda>, ["= 2.10.3"])
    s.add_dependency(%q<rack-test>, [">= 0.5.6"])
  end
end

