class GithubEventsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]
  skip_before_action :authenticate, only: [:create]

  def create
    case request.env['HTTP_X_GITHUB_EVENT']
    when 'ping'
      # do nothing
    when 'pull_request'
      # process_pull_request if payload.action == 'opened'
      raise NotImplementedError
    when 'push'
      process_push
    end

    head :ok
  end

  private

  def payload
    @payload ||= Payload.new(params[:payload] || request.raw_post)
  end

  def repo
    Repo.where(github_id: payload[:repository][:id]).active.first
  end

  def process_push
    BuildJob.enqueue(repo.id, payload[:head_commit][:id])
  end
end
