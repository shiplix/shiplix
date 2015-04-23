class RepoDeactivatorService < ApplicationService
  pattr_initialize :user, :repo

  def call
    return false unless Pundit.policy(user, repo).manage?

    repo.deactivate

    remove_hooks
  end

  private

  def remove_hooks
    return unless repo.hook_id?
    api.remove_hooks(repo.full_github_name, repo.hook_id)
    repo.update(hook_id: nil)
  end
end
