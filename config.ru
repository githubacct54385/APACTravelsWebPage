require './myapp'
require 'sendgrid-ruby'
run Sinatra::Application
$stdout.sync = true