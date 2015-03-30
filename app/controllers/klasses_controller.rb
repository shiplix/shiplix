class KlassesController < ApplicationController
  add_breadcrumb 'Home', :root_path
  add_breadcrumb 'Repositories', :repos_path

  def index
    @klasses = repo.
      klasses.
      in_build(build).
      includes(:metrics).
      order('klass_metrics.rating desc, klass_metrics.smells_count desc').
      paginate(page: params[:page], per_page: 20) if build.present?

    add_index_vars
  end

  def show
    @klass = repo.klasses.find_by!(name: params[:id])
    @metric = @klass.metrics.find_by!(build_id: build.id)
    @smells = @klass.smells.where(build_id: build.id)
    @source_files = @klass.
      source_files.
      joins(:klass_source_files).
      includes(:klass_source_files).
      where(klass_source_files: {build_id: build.id})

    add_index_vars
    add_show_vars
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

  def add_index_vars
    add_breadcrumb "Classes #{repo.full_github_name}", :repo_klasses_path
    title_variables[:repo] = repo.full_github_name
  end

  def add_show_vars
    add_breadcrumb @klass.name, :repo_klass_path
    title_variables[:klass] = @klass.name
  end
end
