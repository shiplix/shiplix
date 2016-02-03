class ReposController < ApplicationController
  include CurrentBuildable

  def index
    scope = current_user.
      repos.
      joins(:owner).
      order("owners.name asc, repos.name asc").
      preload(:owner, :default_branch)

    @repos = scope.active.to_a +
             scope.active(false).where(memberships: {admin: true}).to_a

    # preload memberships for pundit policy
    current_user.memberships.to_a
  end

  def show
    authorize current_repo, :show?

    title_variables[:repo] = @repo.full_name

    @branch = @repo.default_branch

    @changesets = ChangesetsFinder.new(@branch).call if @branch
  end
end
