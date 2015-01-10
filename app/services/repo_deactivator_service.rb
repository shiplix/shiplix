class RepoDeactivatorService
  include Apiable

  pattr_initialize :user, :repo

  def call
    repo.deactivate
  end
end
