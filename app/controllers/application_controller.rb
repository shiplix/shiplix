class ApplicationController < ActionController::Base
  include ErrorsCatch
  include PageInfo
  include Pundit

  protect_from_forgery with: :exception

  before_action :authenticate

  helper_method :current_user, :signed_in?

  protected

  def authenticate
    redirect_to root_path unless signed_in?
  end

  def signed_in?
    current_user.present?
  end

  def current_user
    @current_user ||= User.where(remember_token: session[:remember_token]).first
  end
end
