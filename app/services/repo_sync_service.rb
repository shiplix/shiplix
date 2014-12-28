class RepoSyncService
  ORGANIZATION_TYPE = 'Organization'.freeze

  pattr_initialize :user, :github_token
  attr_reader :user

  def call
    user.repos.clear

    api.repos.each do |resource|
      attributes = repo_attributes(resource.to_hash)
      user.repos << Repo.find_or_create_with(attributes)
    end
  end

  private

  def api
    @api ||= GithubApi.new(github_token)
  end

  def repo_attributes(attributes)
    attributes.slice(:private).merge(
      github_id: attributes[:id],
      full_github_name: attributes[:full_name],
      in_organization: attributes[:owner][:type] == ORGANIZATION_TYPE
    )
  end
end
