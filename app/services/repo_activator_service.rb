class RepoActivatorService
  include Apiable

  pattr_initialize :user, :repo

  def call
    repo.activate(user)

    api.add_hooks(repo.full_github_name, callback_endpoint) do |hook_id|
      repo.update(hook_id: hook_id)
    end

    PushBuildJob.enqueue(repo.id, api.default_branch, recent_revision) if recent_revision.present?
  end

  private

  def recent_revision
    @recent_revision ||= api.recent_revision(repo.full_github_name)
  end

  def callback_endpoint
    "#{ENV.fetch('SHIPLIX_PROTOCOL', 'http')}://#{HOST}/github_events"
  end
end
