ENV['RACK_ENV'] = 'test'
require 'rubygems'
require 'bundler'
Bundler.require
require 'test/unit'
require 'shoulda'
require 'rack/test'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'punchcard'

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
