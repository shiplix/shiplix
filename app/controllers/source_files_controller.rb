class SourceFilesController < ApplicationController
  before_action only: [:index] { title_variables[:repo] = repo.full_github_name }

  # Public: show list of source files in repo
  #
  # Returns text/html
  def index
    @source_files = repo
      .source_files
      .in_build(build)
      .order('source_file_metrics.rating desc, source_file_metrics.smells_count desc')
      .paginate(page: params[:page], per_page: 20) if build.present?

    SourceFile.preload_metric(@source_files, build)
  end

  private

  def repo
    @repo ||= Repo.active.find_by!(full_github_name: params[:repo_id])
  end

  def build
    @build ||= repo.default_branch.try(:recent_push_build)
  end
end
