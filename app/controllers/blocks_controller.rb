class BlocksController < ApplicationController
  before_action only: [:index] { title_variables[:repo] = repo.full_github_name }

  def index
    return unless build

    @blocks = build.
                blocks.
                where("blocks.type = ? or blocks.smells_count > 0", Blocks::Namespace).
                order("blocks.rating desc, blocks.smells_count desc").
                paginate(page: params[:page], per_page: 20)
  end

  private

  def repo
    @repo ||= Repo.active.find_by!(full_github_name: params[:repo_id])
  end

  def build
    @build ||= repo.default_branch.try(:recent_push_build)
  end

  def authenticate
    authorize repo, :show?
  end
end
