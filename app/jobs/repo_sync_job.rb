class RepoSyncJob
  include Retryable
  extend Resque::Single

  @queue = :high

  lock_on { |user_id| [user_id] }

  def self.execute(user_id)
    user = User.find(user_id)
    RepoSyncService.new(user).call
  end
end
