# Example config.ru for running from direct git clone
# See README to see how to launch from gem
require './lib/punchcard'

Punchcard.set :mongo_db, 'punchcard'
run Punchcard