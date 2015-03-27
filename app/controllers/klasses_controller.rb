class KlassesController < ApplicationController
  add_breadcrumb 'Home', :root_path
  add_breadcrumb 'Repositories', :repos_path

  def index
    add_breadcrumb "Classes #{repo.full_github_name}", :repo_klasses_path
    self.title_variables = {repo: repo.full_github_name}

    @klasses = repo.
      klasses.
      in_build(build).
      includes(:metrics).
      order('klass_metrics.rating desc, klass_metrics.smells_count desc').
      paginate(page: params[:page], per_page: 20) if build.present?
  end

  private

  def repo
    @repo ||= Repo.active.find(params[:repo_id])
  end

  def build
    @build ||= repo.default_branch.try(:recent_push_build)
  end

  def authenticate
    authorize repo, :show?
  end
end
