class ApplicationController < ActionController::Base
  include ErrorsCatch
  include PageInfo
  include Pundit

  protect_from_forgery with: :exception

  before_action :authenticate

  helper_method :current_user,
                :signed_in?,
                :current_owner,
                :current_repo,
                :current_branch

  private

  def authenticate
    forbidden unless signed_in?
  end

  def signed_in?
    current_user.present?
  end

  def current_user
    return if session[:remember_token].blank?
    @current_user ||= User.find_by(remember_token: session[:remember_token])
  end

  def api
    @api ||= GithubApi.new(current_user.access_token)
  end

  def current_owner
    return if params[:owner_id].blank?
    @owner ||= Owner.find_by(name: params[:owner_id])
  end

  def current_repo
    return if !current_owner || params[:repo_id].blank?
    @repo ||= current_owner.repos.active.find_by(name: params[:repo_id])
  end

  def current_branch
    return if !current_repo || params[:branch_id].blank?
    @branch ||= current_repo.branches.find_by!(name: params[:branch_id])
  end
end
