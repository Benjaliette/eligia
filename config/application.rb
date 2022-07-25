require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Eligia
  class Application < Rails::Application
    config.generators do |generate|
      generate.assets true
      generate.helper true
      generate.test_framework :rspec, fixture: false
    end
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0
    # To ordanize models with subfolders :
    config.autoload_paths += Dir[Rails.root.join('app', 'models', '**/')]

    config.asset_host = 'https://www.eligia.fr/'

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
