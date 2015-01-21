class RepoDeactivatorService
  include Apiable

  pattr_initialize :user, :repo

  def call
    repo.deactivate

    remove_hooks
  end

  private

  def remove_hooks
    api.remove_hooks(repo.full_github_name, repo.hook_id)
    repo.update(hook_id: nil)
  end
end
