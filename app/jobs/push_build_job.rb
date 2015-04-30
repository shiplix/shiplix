require 'json'

class PushBuildJob < ApplicationJob
  extend Resque::Single

  @queue = :low

  lock_on { |repo_id, branch_name, revision| [repo_id, branch_name, revision] }

  def self.execute(repo_id, branch_name, revision, payload_json = nil)
    # TODO: refactor!!!
    repo = Repo.find(repo_id)
    branch = find_branch(repo, branch_name)

    unless branch
      BranchesSyncService.new(repo).call
      branch = find_branch(repo, branch_name)
      raise "Branch #{branch_name} not found for repo_id #{repo_id}" unless branch
    end

    if payload_json
      payload = Payload::Push.new(payload_json)
    else
      build = branch.push_builds.find_by(revision: revision)

      if build
        payload = build.payload
      else
        # first time build
        payload = Payload::Push.new
        payload.revision = revision
      end
    end

    PushBuildService.new(branch, payload).call
  end

  private

  def self.find_branch(repo, branch_name)
    repo.branches.find_by(name: branch_name)
  end
end
