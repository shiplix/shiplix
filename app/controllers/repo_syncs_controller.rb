class RepoSyncsController < ApplicationController
  respond_to :json

  def create
    Resque.enqueue(
      RepoSyncJob,
      current_user.id,
      session[:github_token]
    )

    respond_to do |format|
      format.json do
        render json: {status: 'ok'}
      end
    end
  end
end
