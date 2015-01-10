class RepoActivationsController < ApplicationController
  respond_to :json

  def update
    render json: {meta_id: enqueue_job(RepoActivationJob)}
  end

  def destroy
    render json: {meta_id: enqueue_job(RepoDeactivationJob)}
  end

  private

  def repo
    @repo ||= current_user.repos.find(params[:id])
  end

  def enqueue_job(klass)
    klass.enqueue(
      current_user.id,
      repo.id
    ).meta_id
  end
end
