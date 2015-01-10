class RepoActivatorService
  include Apiable

  pattr_initialize :user, :repo

  def call
    repo.activate(user)

    PushBuildJob.enqueue(repo.id, default_branch, recent_revision) if recent_revision.present?
  end

  private

  def recent_revision
    @recent_revision ||= api.branch(repo.full_github_name, default_branch).commit.sha
  end

  def default_branch
    api.repository(repo.full_github_name).default_branch
  end
end
