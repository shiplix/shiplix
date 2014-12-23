class JobsController < ApplicationController
  skip_before_action :authenticate, only: [:show]

  respond_to :json

  def show
    meta = Resque::Plugins::Meta.get_meta(params[:id])

    return render(json: {status: 'no meta found'}, status: 404) unless meta

    data = {
      enqueued_at: meta.enqueued_at,
      started_at:  meta.started_at,
      finished_at: meta.finished_at,
      succeeded:   meta.succeeded?,
      failed:      meta.failed?,
      progress:    meta.progress,
      payload:     meta['payload']
    }

    render json: data
  end
end