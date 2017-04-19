require 'bundler'
Bundler.require
require 'json'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'db/development.sqlite'
)

require_all "lib"
