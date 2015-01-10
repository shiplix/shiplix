class RepoDeactivationJob
  include Retryable
  extend Resque::Single

  @queue = :high

  lock_on { |user_id, repo_id| [user_id, repo_id] }

  def self.execute(user_id, repo_id)
    user = User.find(user_id)
    repo = user.repos.find(repo_id)
    RepoDeactivatorService.new(user, repo).call
  end
end
