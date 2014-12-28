class BuildJob
  extend Resque::Single

  @queue = :low

  lock_on { |repo_id, revision| [repo_id, revision] }

  def self.execute(repo_id, revision)
    repo = user.repos.find(repo_id)
    BuildService.new(repo, revision).call
  end
end
