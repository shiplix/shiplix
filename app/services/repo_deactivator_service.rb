class RepoDeactivatorService
  include Apiable

  pattr_initialize :user, :repo

  def call
    repo.deactivate

    remove_hooks
    remove_deploy_key
  end

  private

  def remove_hooks
    return unless repo.hook_id?
    api.remove_hooks(repo.full_github_name, repo.hook_id)
    repo.update(hook_id: nil)
  end

  def remove_deploy_key
    return unless repo.deploy_key_id?
    api.remove_deploy_key(repo.full_github_name, repo.deploy_key_id)
    repo.update(deploy_key_id: nil)
  end
end
