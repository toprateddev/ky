# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Spectical::Application.initialize!

#Rails.application.config.to_prepare do
#  Devise::SessionsController.layout 'users'
#  Devise::RegistrationsController.layout 'users'
#  Devise::ConfirmationsController.layout 'users'
#  Devise::UnlocksController.layout 'users'
#  Devise::PasswordsController.layout 'users'
#end