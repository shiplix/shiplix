class KlassesController < ApplicationController
  before_action only: [:index, :show] { title_variables[:repo] = repo.full_github_name }

  def index
    return unless build

    @klasses = build
                .blocks
                .where(type: Blocks::Namespace)
                .order('rating desc, smells_count desc')
                .paginate(page: params[:page], per_page: 20)

  end

  def show
    return render_error(404) unless build
    title_variables[:klass] = klass.name

    # TODO: Think about where we can load file content from github
    # and cache it. It`s not contoller role.
    klass.files.each do |file|
      file.content = api.file_contents(repo.full_github_name,
                                       file.name,
                                       build.revision)
    end
  end

  private

  def repo
    @repo ||= Repo.active.find_by!(full_github_name: params[:repo_id])
  end

  def build
    @build ||= repo.default_branch.try(:recent_push_build)
  end

  def klass
    @klass ||= build.namespaces.find_by!(name: params[:id])
  end

  def authenticate
    authorize repo, :show?
  end
end
