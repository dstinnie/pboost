class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  force_ssl if: :ssl_configured?
  before_action :authenticate_user!

  def ssl_configured?
    %w(staging production).include?(Rails.env)
  end

  def require_admin_user!
    render file: "#{Rails.root}/public/403.html", status: 403, layout: false unless admin_user?
  end

  def admin_user?
    user_signed_in? && current_user.is_in_role?('Administrator')
  end
  helper_method :admin_user?

protected

  def devise_parameter_sanitizer
    if resource_class == User
      User::ParameterSanitizer.new(User, :user, params)
    else
      super # Use the default one
    end
  end
end
