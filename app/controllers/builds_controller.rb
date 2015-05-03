class BuildsController < ApplicationController
  respond_to :json

  # Public: refresh build
  #
  # Returns text/json
  def create
    repo = Repo.find(params.require(:repo_id))

    unless RepoPolicy.new(current_user, repo).manage?
      render json: {status: 'error'}, status: :forbidden
      return
    end

    branch_name = params.require(:branch)
    meta_id = Builds::Pushes::EnqueueRecentService.new(current_user, repo, branch_name: branch_name).call

    if meta_id
      render json: {meta_id: meta_id}
    else
      render json: {status: 'error'}, status: :bad_request
    end
  end
end
