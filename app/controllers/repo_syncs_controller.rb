class RepoSyncsController < ApplicationController
  respond_to :json

  def create
    meta_id = RepoSyncJob.enqueue(current_user.id).meta_id

    render json: {meta_id: meta_id}
  end
end
