require 'bundler'
Bundler.require

class Punchcard < Sinatra::Base
  get '/' do
    "foo"
  end
end