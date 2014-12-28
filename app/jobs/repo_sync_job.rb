class RepoSyncJob
  include Retryable
  extend Resque::Single

  @queue = :high

  lock_on { |user_id, *| [user_id] }

  def self.execute(user_id, github_token)
    user = User.find(user_id)
    synchronization = RepoSyncService.new(user, github_token)
    synchronization.call
  end
end
