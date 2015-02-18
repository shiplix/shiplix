class ReposController < ApplicationController
  def index
    @repos = current_user.
      repos.
      active.
      order(full_github_name: :asc)

    @repos |= current_user.
      repos.
      active(false).
      where(memberships: {admin: true}).
      order(full_github_name: :asc)

    # preload memberships for pundit policy
    current_user.memberships.to_a
  end
end
