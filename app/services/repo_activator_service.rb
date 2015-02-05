class RepoActivatorService
  include Apiable

  pattr_initialize :user, :repo

  def call
    repo.transaction do
      repo.activate(user)
      add_hooks
    end

    if recent_revision.present?
      PushBuildJob.enqueue(repo.id, api.default_branch(repo.full_github_name), recent_revision)
    end
  end

  private

  def add_hooks
    api.add_hooks(repo.full_github_name, callback_endpoint) do |hook_id|
      repo.update(hook_id: hook_id)
    end
  end

  def recent_revision
    @recent_revision ||= api.recent_revision(repo.full_github_name)
  end

  def callback_endpoint
    "#{ENV.fetch('SHIPLIX_PROTOCOL', 'http')}://#{HOST}/github_events"
  end
end
