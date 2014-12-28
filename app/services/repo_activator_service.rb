class RepoActivatorService
  include Apiable

  pattr_initialize :repo, :github_token

  def call
    repo.activate

    if !repo.builds.exists? && recent_revision
      BuildJob.enqueue(repo.id, recent_revision, github_token)
    end
  end

  private

  def recent_revision
    @recent_revision ||= api.branch(repo.full_github_name, default_branch).commit.sha
  end

  def default_branch
    api.repository(repo.full_github_name).default_branch
  end
end
