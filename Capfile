# Load DSL and Setup Up Stages
require 'capistrano/setup'

# Includes default deployment tasks
require 'capistrano/deploy'

require 'rvm1/capistrano3'
require 'capistrano/bundler'
require 'capistrano/rails/assets'
#require "whenever/capistrano"

require 'capistrano/unicorn'

require 'capistrano/rails/console'

# Loads custom tasks from `lib/capistrano/tasks' if you have any defined.
Dir.glob('lib/capistrano/tasks/*.cap').each { |r| import r }
