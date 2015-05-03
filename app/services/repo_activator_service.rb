class RepoActivatorService < ApplicationService
  pattr_initialize :user, :repo

  def call
    return false unless Pundit.policy(user, repo).manage?

    repo.transaction do
      repo.activate(user)
      add_hooks
    end

    Builds::Pushes::EnqueueRecentService.new(user, repo)
  end

  private

  def add_hooks
    api.add_hooks(repo.full_github_name, callback_endpoint) do |hook_id|
      repo.update(hook_id: hook_id)
    end
  end

  def callback_endpoint
    "#{ENV.fetch('SHIPLIX_PROTOCOL', 'http')}://#{HOST}/github_events"
  end
end
