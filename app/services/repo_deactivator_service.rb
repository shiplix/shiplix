class RepoDeactivatorService
  pattr_initialize :repo, :github_token
  attr_reader :repo

  def call
    repo.deactivate
  end

  private

  def api
    @api ||= GithubApi.new(github_token)
  end
end
