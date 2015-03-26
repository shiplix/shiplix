class BuildsController < ApplicationController
  respond_to :json

  # Public: refresh build
  #
  # Returns text/json
  def create
    repo = Repo.find(params[:repo_id])
    return head(:bad_request) unless RepoPolicy.new(current_user, repo).manage?

    if revision = GithubApi.new(current_user.access_token).recent_revision(repo.name, params[:branch])
      meta_id = PushBuildJob.enqueue(repo.id, params[:branch], revision).meta_id

      render json: {meta_id: meta_id}
    else
      head(:bad_request)
    end
  end
end
