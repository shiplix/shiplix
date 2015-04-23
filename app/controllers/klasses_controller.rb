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

    build_id = build.id
    Preloader.new(@klasses).
      preload(:metrics) { where(build_id: build_id) }
  end

  def show
    return render_error(404) unless build

    build_id = build.id
    Preloader.new(klass).
      preload([:metrics, :smells, :klass_source_files]) { where(build_id: build_id) }.
      preload([:source_files, {smells: {locations: :source_file}}])

    klass.source_files.each do |source_file|
      source_file.content = api.file_contents(repo.full_github_name,
                                              source_file.path,
                                              build.revision)
    end

    @klass = klass.decorate
  end

  private

  def repo
    @repo ||= Repo.active.find_by!(full_github_name: params[:repo_id])
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
