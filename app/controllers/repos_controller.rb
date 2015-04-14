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
  end

  private

  def repo
    @repo ||= Repo.active.find(params[:id])
  end

  def authenticate
    case action_name
    when 'index'
      super
    when 'show'
      authorize repo, :show?
    else
      raise 'Unknown action'
    end
  end
end
