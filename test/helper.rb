require 'rubygems'
require 'bundler'
Bundler.require
require 'test/unit'
require 'shoulda'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'punchcard'

Punchcard.set :mongo_db, 'punchcard_test'

class Test::Unit::TestCase
  def setup
    Person.delete_all
  end
end
