class ApplicationController < ActionController::Base
  include PageInfo

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  layout 'slate'

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
end
