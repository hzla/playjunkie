require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
Dotenv.load
module Qwizzy
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
   ActionMailer::Base.smtp_settings = {
    
    :user_name => 'playjunkie',
    :password => ENV['SENDGRID_PASSWORD'],
    :domain => 'playjunkie.com',
    :address => 'smtp.sendgrid.net',
    :port => 587,
    :authentication => :plain,
    :enable_starttls_auto => true
  }

  config.assets.paths << Rails.root.join('vendor', 'assets', 'fonts')  
  config.assets.precompile << /\.(?:svg|eot|woff|ttf)$/




  end
end
