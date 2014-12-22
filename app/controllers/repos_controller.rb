class ReposController < ApplicationController
  def index
    @repos = current_user.
      repos.
      order(active: :desc, full_github_name: :asc)
  end
end
