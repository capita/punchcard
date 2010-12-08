# Example config.ru for running from direct git clone
# See README to see how to launch from gem
require './lib/punchcard'

Punchcard.set :mongo_db, 'punchcard'

Punchcard.use Rack::Auth::Basic do |username, password|
  [username, password] == ['admin', 'admin']
end

run Punchcard