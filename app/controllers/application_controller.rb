class ApplicationController < ActionController::Base
  include PageInfo

  protect_from_forgery with: :exception

  layout 'slate'

  before_action :authenticate

  helper_method :current_user, :signed_in?

  def self.catch_errors
    rescue_from Exception, :with => :catch_500
    rescue_from ActiveRecord::RecordNotFound, :with => :catch_404
  end

  catch_errors if Rails.env.production?

  def catch_404
    render_error(404)
  end

  def catch_500
    render_error(500)
  end

  protected

  def render_error(status)
    @last_error = status.to_s

    respond_to do |format|
      format.html { render "layouts/error_#{status}", :status => status }
      format.all { render :nothing => true, :status => status }
    end
  end

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
