module ErrorsCatch
  extend ActiveSupport::Concern

  included do
    def self.catch_errors
      rescue_from Exception, with: :catch_500
      rescue_from ActiveRecord::RecordNotFound, with: :catch_404
      rescue_from ActionController::ParameterMissing, with: :catch_404
      rescue_from Pundit::NotAuthorizedError, with: :catch_404
    end

    catch_errors unless Rails.env.development?
  end

  def catch_404(exception = nil)
    render_error(404, exception)
  end

  def catch_500(exception = nil)
    render_error(500, exception)
  end

  def render_error(status, exception = nil)
    if exception && !Rails.env.production? && Rails.logger
      Rails.logger.error(exception.message)
      Rails.logger.error(exception.backtrace.join("\n"))
    end

    @last_error = status.to_s
    @exception = exception

    respond_to do |format|
      format.html { render "errors/error_#{status}", status: status }
      format.all { render nothing: true, status: status }
    end
  end
end
