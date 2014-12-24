class GithubEventsController < ApplicationController
  before_action :ignore_confirmation_pings, only: [:create]
  skip_before_action :verify_authenticity_token, only: [:create]
  skip_before_action :authenticate, only: [:create]

  def create
    head :ok
  end

  private

  def ignore_confirmation_pings
    head :ok if payload.ping?
  end

  def payload
    @payload ||= Payload.new(params[:payload] || request.raw_post)
  end
end
