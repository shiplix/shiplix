class ReposController < ApplicationController
  def index
    scope = current_user.
      repos.
      order(full_github_name: :asc).
      preload(:default_branch)

    @repos = scope.active.to_a +
             scope.active(false).where(memberships: {admin: true}).to_a

    # preload memberships for pundit policy
    current_user.memberships.to_a
  end

  def show
    @repo = Repo.active.find_by!(full_github_name: params.require(:id))

    authorize @repo, :show?

    title_variables[:repo] = @repo.full_github_name

    @branch = @repo.default_branch

    @changesets = ChangesetsFinder.new(@branch).call if @branch
  end
end
