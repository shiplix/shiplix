class BranchesSyncService
  include Apiable

  pattr_initialize :repo

  attr_reader :user

  def call
    @user = repo.owner

    cleanup_branches
    add_branches
    set_default
  end

  private

  def api_branches
    @api_branches ||= api.branches(repo.full_github_name).index_by(&:name)
  end

  def cleanup_branches
    repo.branches.each do |branch|
      branch.destroy unless api_branches.key?(branch.name)
    end
  end

  def add_branches
    repo_branches = repo.branches.index_by(&:name)

    api_branches.each do |name, resource|
      repo.branches.create!(name: name) unless repo_branches.key?(name)
    end
  end

  def set_default
    branch = repo.branches.detect { |branch| branch.name == default_branch }
    return if branch.default?

    prev_default = repo.branches.detect(&:default?)
    prev_default.update(default: false) if prev_default

    branch.update(default: true)
  end

  def default_branch
    @default_branch ||= api.repository(repo.full_github_name).default_branch
  end
end
