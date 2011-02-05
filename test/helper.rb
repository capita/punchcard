ENV['RACK_ENV'] = 'test'
require 'rubygems'
require 'bundler/setup'
require 'punchcard'

require 'test/unit'
require 'shoulda'
require 'rack/test'
require 'timecop'

# DB setup
require 'logger'
system 'rm ./punchcard_test.sqlite3'
ActiveRecord::Migrator.migrate(File.join(File.dirname(__FILE__), "../lib/db/migrate"))

class Test::Unit::TestCase
  def setup
    Person.delete_all
    Punch.delete_all
  end
end
