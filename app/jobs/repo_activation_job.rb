class RepoActivationJob
  include Retryable
  extend Resque::Single

  @queue = :high

  lock_on { |user_id, repo_id, *| [user_id, repo_id] }

  def self.execute(user_id, repo_id, github_token)
    user = User.find(user_id)
    repo = user.repos.find(repo_id)
    RepoActivatorService.new(repo, github_token).call
  end
end
