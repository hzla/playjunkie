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
   config.action_mailer.smtp_settings = {
    address: "smtp.gmail.com",
    port: 587,
    domain: "example.com",
    authentication: "plain",
    enable_starttls_auto: true,
    user_name: "jgsdat@gmail.com",
    password: "andylee1"
  }

  config.assets.paths << Rails.root.join('vendor', 'assets', 'fonts')  
  config.assets.precompile << /\.(?:svg|eot|woff|ttf)$/




  end
end
