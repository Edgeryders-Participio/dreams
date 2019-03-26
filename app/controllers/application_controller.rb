class ApplicationController < ActionController::Base
  include AppSettings
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_locale
  before_action :set_paper_trail_whodunnit

  helper_method :app_setting

  def not_found
    render file: "public/404.html", status: :not_found
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:ticket_id])
  end

  def set_locale
    if !cookies[:locale] || params[:lang]
      I18n.locale = cookies[:locale] = the_new_locale.to_s
    else
      I18n.locale = cookies[:locale]
    end
  end

  def the_new_locale
    new_locale = (params[:lang] || I18n.default_locale)
    ['en', 'he'].include?(new_locale) ? new_locale : I18n.default_locale.to_s
  end

  private

  def assert(condition, message, params = {})
    return if condition
    flash[:alert] = t(message, params)
    redirect_to failure_path
  end

  def failure_path
    raise NotImplementedError.new
  end
end
