# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "punchcard/version"

Gem::Specification.new do |s|
  s.name        = "punchcard"
  s.version     = Punchcard::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Christoph Olszowka"]
  s.email       = ["christoph at olszowka de"]
  s.homepage    = "https://github.com/capita/punchcard"
  s.summary     = %Q{Simple sinatra/activerecord based app for tracking time when people have been in the office}
  s.description = %Q{Simple sinatra/activerecord based app for tracking time when people have been in the office}

  s.rubyforge_project = "punchcard"
  
  s.add_dependency 'sinatra', ">= 1.0.0"
  s.add_dependency 'haml', '>= 3.0.24'
  s.add_dependency 'sass', '>= 3.0.0'
  s.add_dependency 'activerecord', '~> 3.0.0'
  s.add_dependency 'gravtastic', '>= 0'
  s.add_development_dependency "shoulda", "2.10.3"
  s.add_development_dependency "rack-test", ">= 0.5.6"
  s.add_development_dependency 'sqlite3', '>= 0'
  s.add_development_dependency 'timecop', '>= 0'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end