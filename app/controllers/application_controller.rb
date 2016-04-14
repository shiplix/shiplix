class ApplicationController < ActionController::Base
  include ErrorsCatch
  include PageInfo
  include Pundit

  protect_from_forgery with: :exception

  before_action :authenticate

  helper_method :current_user, :signed_in?

  private

  def authenticate
    render_error(403) unless signed_in?
  end

  def signed_in?
    current_user.present?
  end

  def current_user
    @current_user ||= User.find_by(remember_token: session[:remember_token])
  end

  def api
    @api ||= GithubApi.new(current_user.access_token)
  end

  def current_owner
    @owner ||= Owner.find_by!(name: params.require(:owner_id))
  end

  def current_repo
    @repo ||= current_owner.repos.active.find_by!(name: params.require(:repo_id))
  end

  def current_branch
    @branch ||= current_repo.branches.find_by!(name: params.require(:branch_id))
  end
end
