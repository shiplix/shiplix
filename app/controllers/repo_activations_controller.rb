class RepoActivationsController < ApplicationController
  respond_to :json

  def create
    meta_id = RepoActivationJob.enqueue(
      current_user.id,
      repo.id,
      session[:github_token]
    ).meta_id

    render json: {meta_id: meta_id}
  end

  private

  def repo
    @repo ||= current_user.repos.find(params[:id])
  end
end
