module ErrorsCatch
  extend ActiveSupport::Concern

  included do
    def self.catch_errors
      rescue_from "Exception", with: :server_error

      rescue_from "ActiveRecord::RecordNotFound",
                  "ActionController::ParameterMissing",
                  with: :not_found

      rescue_from "Pundit::NotAuthorizedError", with: :forbidden
    end

    catch_errors unless Rails.env.development?
  end

  def not_found(exception = nil)
    render_error(404, exception)
  end

  def server_error(exception = nil)
    render_error(500, exception)
  end

  def forbidden(exception = nil)
    render_error(403, exception)
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
