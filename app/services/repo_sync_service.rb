class RepoSyncService
  include Apiable

  ORGANIZATION_TYPE = 'Organization'.freeze

  pattr_initialize :user

  attr_reader :current_repos

  def call
    find_or_create_repos
    destroy_memberships
    create_memberships
  end

  private

  def find_or_create_repos
    @current_repos = api.repos.each_with_object({}) do |repo_params, hsh|
      attributes = repo_attributes(repo_params)
      repo = Repo.find_by(github_id: attributes[:github_id]) || Repo.create!(attributes)
      hsh[repo.id] = {record: repo, params: repo_params}
    end
  end

  def destroy_memberships
    user.memberships.each do |membership|
      membership.destroy unless current_repos[membership.repo_id]
    end
  end

  def create_memberships
    memberships = user.memberships.index_by(&:repo_id)

    current_repos.each do |repo_id, repo|
      membership = memberships[repo_id]

      if membership && membership.admin? != repo[:params][:permissions][:admin]
        membership.update!(admin: repo[:params][:permissions][:admin])
      elsif !membership
        user.memberships.create!(repo: repo[:record], admin: repo[:params][:permissions][:admin])
      end
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
