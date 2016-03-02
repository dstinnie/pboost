Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false
  config.action_controller.asset_host = '//localhost:5000'

#  ActionController::Base.asset_host = Proc.new { |source, request|
#    if request.env["REQUEST_PATH"].include? ".pdf"
#      "file:#{Rails.root.join('public')}"
#    else
#      "#{request.protocol}#{request.host_with_port}"
#    end
#  }

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = true
  ActionMailer::Base.smtp_settings = {
    :address        => 'mail.wilsonsdev.com',
    :port           => '587',
    :authentication => :plain,
    :user_name      => ENV['SENDGRID_USERNAME'],
    :password       => ENV['SENDGRID_PASSWORD'],
    :domain         => 'wilsonsdev.com',
    :enable_starttls_auto => true,
    :openssl_verify_mode => 'none'
  }
  config.action_mailer.default_url_options = { host: ENV['HOST_DOMAIN'], port: ENV['PORT'] || 3000 }

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true
  
  config.quiet_assets = true # false to turn off temporarily

  # Configure Bullet to suggest query optimizations
  config.after_initialize do
    Bullet.enable = true
  #  Bullet.alert = true
    Bullet.bullet_logger = true
  #  Bullet.console = true
  #  Bullet.growl = true
  #  Bullet.xmpp = { :account  => 'bullets_account@jabber.org',
  #                  :password => 'bullets_password_for_jabber',
  #                  :receiver => 'your_account@jabber.org',
  #                  :show_online_status => true }
  #  Bullet.rails_logger = true
  #  Bullet.bugsnag = true
  #  Bullet.airbrake = true
  #  Bullet.add_footer = true
  #  Bullet.stacktrace_includes = [ 'your_gem', 'your_middleware' ]
  end
end
