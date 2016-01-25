class ReposController < ApplicationController
  def index
    @repos = current_user.
      repos.
      active.
      order(full_github_name: :asc).
      includes(default_branch: [:recent_push_build])

    @repos |= current_user.
      repos.
      active(false).
      where(memberships: {admin: true}).
      order(full_github_name: :asc)

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
