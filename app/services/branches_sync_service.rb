class BranchesSyncService
  include Apiable

  pattr_initialize :repo

  def call
    cleanup_branches
    add_branches
    set_default
  end

  private

  def api_branches
    @api_branches ||= api.branches(repo.full_github_name)
  end

  def api_default_branch
    @default_branch ||= api.default_branch(repo.full_github_name)
  end

  def cleanup_branches
    repo.branches.each do |branch|
      next if api_branches.key?(branch.name)
      last_build = branch.recent_push_build
      ScmCleanService.new(last_build).call if last_build
      branch.destroy
    end
  end

  def add_branches
    repo_branches = repo.branches.index_by(&:name)

    api_branches.each do |name, resource|
      repo.branches.create!(name: name) unless repo_branches.key?(name)
    end
  end

  def set_default
    branch = repo.branches.detect { |branch| branch.name == api_default_branch }
    return if branch.default?

    prev_default = repo.branches.find(&:default?)
    prev_default.update(default: false) if prev_default

    branch.update(default: true)
  end

  def user
    repo.owner
  end
end
