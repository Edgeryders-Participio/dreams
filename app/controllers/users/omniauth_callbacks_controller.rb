class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token, only: :saml

  def facebook
    @user = User.from_omniauth(request.env["omniauth.auth"])
    
    sign_in_and_redirect @user, :event => :authentication
    set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
  end

  def saml
    @user = User.from_omniauth(request.env["omniauth.auth"])

    c = Rails.application.config.x.firestarter_settings
    sign_in_and_redirect @user, event: :authentication #this will throw if @user is not activated
    set_flash_message(:notice, :success, kind: c['saml_human_name']) if is_navigational_format?
  end

  def failure
    redirect_to root_path
  end
end
