ENV["RAILS_ENV"] = "test"
PLUGIN_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..'))
require 'rubygems'
require 'spec'
require 'active_support'
require 'action_controller'
require 'action_view'
require File.join(PLUGIN_ROOT, 'init.rb')

ActionController::Base.perform_caching = false
ActionController::Base.consider_all_requests_local = true
ActionController::Base.allow_forgery_protection    = false


Spec::Runner.configure do |config|
   
   # == Mock Framework
   #
   # RSpec uses it's own mocking framework by default. If you prefer to
   # use mocha, flexmock or RR, uncomment the appropriate line:
   #
   # config.mock_with :mocha
   # config.mock_with :flexmock
   # config.mock_with :rr
   
end
