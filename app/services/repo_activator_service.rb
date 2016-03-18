class RepoActivatorService < ApplicationService
  pattr_initialize :user, :repo

  def call
    return false unless Pundit.policy(user, repo).activate?

    repo.transaction do
      repo.activate(user)
      add_hooks
    end

    Builds::Pushes::EnqueueRecentService.new(user, repo).call
  end

  private

  def add_hooks
    api.add_hooks(repo.full_name, GithubApi::CALLBACK_ENDPOINT) do |hook_id|
      repo.update(hook_id: hook_id)
    end
  end
end
