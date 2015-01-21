class RepoSyncService
  include Apiable

  ORGANIZATION_TYPE = 'Organization'.freeze

  pattr_initialize :user

  def call
    current_repos = find_or_create_repos

    user.memberships.each do |membership|
      membership.destroy unless current_repos[membership.repo_id]
    end

    memberships = user.memberships.index_by(&:repo_id)
    current_repos.each do |repo_id, repo|
      user.repos << repo unless memberships[repo_id]
    end
  end

  private

  def find_or_create_repos
    api.repos.each_with_object({}) do |repo, hsh|
      attributes = repo_attributes(repo)
      repo = Repo.find_or_create_with(attributes)
      hsh[repo.id] = repo
    end
  end

  def repo_attributes(attributes)
    attributes.slice(:private).merge(
      github_id: attributes[:id],
      full_github_name: attributes[:full_name],
      in_organization: attributes[:owner][:type] == ORGANIZATION_TYPE
    )
  end
end
