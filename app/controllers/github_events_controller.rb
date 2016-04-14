class GithubEventsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]
  skip_before_action :authenticate, only: [:create]

  before_action :verify_signature

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

  def verify_signature
    head 400 unless Rack::Utils.secure_compare(github_signature, request.env['HTTP_X_HUB_SIGNATURE'])
  end

  def github_signature
    "sha1=#{OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), ENV['GITHUB_SECRET_TOKEN'], request.body.read)}"
  end

  def payload_data
    params[:payload] || request.raw_post
  end

  def repo
    Repo.active.find_by!(github_id: @payload.repo_id)
  end

  def process_push
    @payload = Payload::Push.new(payload_data)
    Builds::LaunchJob.enqueue(repo.id, @payload.to_json)
  end
end
