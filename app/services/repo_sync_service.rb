class RepoSyncService < ApplicationService
  OWNER_TYPE = {"Organization" => "Owners::Org", "User" => "Owners::User"}.freeze

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
      owner = find_or_create_owner(repo_params[:owner])

      repo = Repo.find_by(github_id: repo_params[:id])
      repo.update(owner: owner) if repo && repo.owner != owner
      repo ||= Repo.create!(repo_attributes(repo_params).merge!(owner: owner))

      hsh[repo.id] = {record: repo, params: repo_params}
    end
  end

  def find_or_create_owner(owner_params)
    name = owner_params[:login]
    Owner.find_by(name: name) || Owner.create!(name: name, type: OWNER_TYPE[owner_params[:type]])
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

      is_admin = repo[:params][:permissions][:admin]
      if membership && membership.admin? != is_admin
        membership.update!(admin: is_admin)
      elsif !membership
        user.memberships.create!(repo: repo[:record], admin: is_admin)
      end
    end
  end

  def repo_attributes(repo_params)
    repo_params.slice(:private).merge!(
      github_id: repo_params[:id],
      name: repo_params[:name]
    )
  end
end
