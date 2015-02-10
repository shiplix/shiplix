class ReposController < ApplicationController
  def index
    @repos = current_user.
      repos.
      order(active: :desc, full_github_name: :asc)

    # preload memberships for pundit policy
    current_user.memberships.to_a
  end
end
