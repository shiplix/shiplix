class SourceFilesController < ApplicationController
  before_action only: [:index] { title_variables[:repo] = repo.full_github_name }

  # Public: show list of source files in repo
  #
  # Returns text/html
  def index
    return unless build.present?

    @source_files = build
      .files
      .order_by_rating(:desc)
      .order_by_smells_count(:desc)
      .paginate(page: params[:page], per_page: 20)
  end

  private

  def repo
    @repo ||= Repo.active.find_by!(full_github_name: params[:repo_id])
  end

  def build
    @build ||= repo.default_branch.try(:recent_push_build)
  end
end
