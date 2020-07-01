require_relative 'boot'
require 'active_storage'
require 'rails/all'
require "action_mailer/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
if defined?(ActionMailer)
  class Devise::Mailer < Devise.parent_mailer.constantize
    # whatever was already there
  end
else
  if Rails::Version::MAJOR >= "6"
    Rails.autoloaders.main.ignore("#{__dir__}/relative/path/to/devise/mailer.rb")
  end
end
module Chatapp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0
    config.time_zone = 'Tokyo'
    config.active_record.default_timezone = :local
    # config.active_storage.routes_prefix = "/files"
    config.i18n.default_locale = :ja
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '.{rb,yml}').to_s]
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
