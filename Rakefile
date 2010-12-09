require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "punchcard"
    gem.summary = %Q{Simple sinatra/activerecord based app for tracking time when people have been in the office}
    gem.description = %Q{Simple sinatra/activerecord based app for tracking time when people have been in the office}
    gem.email = "christoph at olszowka de"
    gem.homepage = "http://github.com/colszowka/punchcard"
    gem.authors = ["Christoph Olszowka"]
    gem.add_dependency 'sinatra', ">= 1.0.0"
    gem.add_dependency 'bson_ext', '>= 0'
    gem.add_dependency 'haml', '>= 3.0.24'
    gem.add_dependency 'sass', '>= 3.0.0'
    gem.add_dependency 'activerecord', '~> 3.0.0'
    gem.add_dependency 'gravtastic', '>= 0'
    gem.add_development_dependency "shoulda", "2.10.3"
    gem.add_development_dependency "rack-test", ">= 0.5.6"
    gem.add_development_dependency 'sqlite3', '>= 0'
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "punchcard #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
