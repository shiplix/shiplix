class RepoActivatorService
  include Apiable

  pattr_initialize :user, :repo

  def call
    repo.activate(user)

    create_hooks

    PushBuildJob.enqueue(repo.id, default_branch, recent_revision) if recent_revision.present?
  end

  private

  def recent_revision
    @recent_revision ||= api.branch(repo.full_github_name, default_branch).commit.sha
  end

  def default_branch
    api.repository(repo.full_github_name).default_branch
  end

  def create_hooks
    hook = api.create_hook(
      repo.full_github_name,
      'web',
      {url: callback_endpoint},
      {events: %w(push pull_request), active: true}
    )

    repo.update(hook_id: hook.id)
  rescue Octokit::UnprocessableEntity => error
    raise unless error.message.include? 'Hook already exists'
  end

  def callback_endpoint
    "#{ENV.fetch('SHIPLIX_PROTOCOL', 'http')}://#{HOST}/github_events"
  end
end
