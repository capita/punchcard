# Rake tasks for punchcard, import with require 'punchcard/tasks'

namespace :db do
  desc "Migrate the database"
  task(:migrate) do
    require 'logger'
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    ActiveRecord::Migration.verbose = false
    ActiveRecord::Migrator.migrate(File.join(File.dirname(__FILE__), "../db/migrate"))
  end
end
