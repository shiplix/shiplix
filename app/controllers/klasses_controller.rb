class KlassesController < ApplicationController
  before_action only: [:index, :show] { title_variables[:repo] = repo.full_github_name }
  before_action only: [:show] { title_variables[:klass] = klass.name }

  def index
    return unless build

    @klasses = repo.
      klasses.
      in_build(build).
      order('klass_metrics.rating desc, klass_metrics.smells_count desc').
      paginate(page: params[:page], per_page: 20)

    Klass.preload_metric(@klasses, build)
  end

  def show
    return render_error(404) unless build

    Klass.preload_metric(klass, build)
    Klass.preload_smells(klass, build)
    Klass.preload_source_files(klass, build)
  end

  private

  def repo
    @repo ||= Repo.active.find(params[:repo_id])
  end

  def build
    @build ||= repo.default_branch.try(:recent_push_build)
  end

  def klass
    @klass ||= repo.klasses.find_by!(name: params[:id])
  end

  def authenticate
    authorize repo, :show?
  end
end
