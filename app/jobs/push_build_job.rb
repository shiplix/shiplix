class PushBuildJob
  extend Resque::Single

  @queue = :low

  lock_on { |repo_id, branch_name, revision| [repo_id, branch_name, revision] }

  def self.execute(repo_id, branch_name, revision)
    repo = Repo.find(repo_id)
    branch = find_branch(repo, branch_name)

    unless branch
      BranchesSyncService.new(repo).call
      branch = find_branch(repo, branch_name)
      raise "Branch #{branch_name} not found for repo_id #{repo_id}" unless branch
    end

    PushBuildService.new(branch, revision).call if branch
  end

  private

  def self.find_branch(repo, branch_name)
    repo.branches.where(name: branch_name).first
  end
end
