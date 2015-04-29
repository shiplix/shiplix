require 'json'

class PushBuildJob
  extend Resque::Single

  @queue = :low

  lock_on { |repo_id, branch_name, revision| [repo_id, branch_name, revision] }

  def self.execute(repo_id, branch_name, revision, payload_json)
    repo = Repo.find(repo_id)
    branch = find_branch(repo, branch_name)

    unless branch
      BranchesSyncService.new(repo).call
      branch = find_branch(repo, branch_name)
      raise "Branch #{branch_name} not found for repo_id #{repo_id}" unless branch
    end

    if payload_json.blank?
      build = branch.push_builds.find_by!(revision: revision)
      payload = build.payload
    else
      payload = Payload::Push.new(payload_json)
    end

    PushBuildService.new(branch, revision, payload).call
  end

  private

  def self.find_branch(repo, branch_name)
    repo.branches.find_by(name: branch_name)
  end
end
