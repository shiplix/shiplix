class RepoDeactivatorService
  include Apiable

  pattr_initialize :repo, :github_token

  def call
    repo.deactivate
  end
end
