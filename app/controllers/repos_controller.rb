class ReposController < ApplicationController
  add_breadcrumb 'Home', :root_path

  def index
    add_breadcrumb 'Repositories', :repos_path

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
end
