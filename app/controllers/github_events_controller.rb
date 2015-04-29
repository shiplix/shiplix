class GithubEventsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]
  skip_before_action :authenticate, only: [:create]

  attr_reader :payload

  def create
    case request.env['HTTP_X_GITHUB_EVENT']
    when 'ping'
      # do nothing
    when 'pull_request'
      raise NotImplementedError
    when 'push'
      process_push
    end

    head :ok
  end

  private

  def payload_data
    params[:payload] || request.raw_post
  end

  def repo
    Repo.where(github_id: @payload.repo_id).active.first
  end

  def process_push
    @payload = Payload::Push.new(payload_data)
    PushBuildJob.enqueue(repo.id, payload.branch, payload.revision, payload.data.to_json)
  end
end
