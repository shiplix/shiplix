class KlassesController < ApplicationController
  add_breadcrumb 'Home', :root_path
  add_breadcrumb 'Repositories', :repos_path

  def index
    if build
      @klasses = repo.
        klasses.
        in_build(build).
        order('klass_metrics.rating desc, klass_metrics.smells_count desc').
        paginate(page: params[:page], per_page: 20)

      Klass.preload_metric(@klasses, build)
    end

    add_index_vars
  end

  def show
    @klass = repo.klasses.find_by!(name: params[:id])
    Klass.preload_metric(@klass, build)
    Klass.preload_smells(@klass, build)
    Klass.preload_source_files(@klass, build)

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
