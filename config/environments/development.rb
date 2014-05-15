Spectical::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.
  config.secret_key = '305a707e05100af9951b5dddcbf6eea2b6859cdab5819fb274e5ad9c796b6b7d33b833aed26bc618432992fdf8f72a6c675cc4718c0b23a8e432ca3f56d1643f'
  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false
  #added fonts path
  config.assets.paths << Rails.root.join('app', 'assets', 'fonts')
  # Precompile additional assets
  config.assets.precompile += %w( .svg .eot .woff .ttf )
  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations
  #config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true
end
