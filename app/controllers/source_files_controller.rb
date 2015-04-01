class SourceFilesController < ApplicationController
  add_breadcrumb 'Home', :root_path
  add_breadcrumb 'Repositories', :repos_path

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

    add_index_vars
  end

  private

  def repo
    @repo ||= Repo.active.find(params[:repo_id])
  end

  def build
    @build ||= repo.default_branch.try(:recent_push_build)
  end

  def add_index_vars
    add_breadcrumb "Source files #{repo.full_github_name}", :repo_source_files_path
    self.title_variables = {repo: repo.full_github_name}
  end
end
