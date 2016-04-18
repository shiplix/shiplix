class FilesController < ApplicationController
  def index
    return not_found unless current_branch
    authorize current_repo, :show?

    @files = FilesFinder.new(current_branch, page: params.fetch(:page, 1), per_page: 20)

    title_variables[:repo] = current_repo.full_name
  end

  def show
    return not_found unless current_branch
    authorize current_repo, :show?

    @file = current_branch.files.find_by!(path: params.require(:id))

    @file.content = api.file_contents(current_repo.full_name,
                                      @file.path,
                                      current_branch.recent_push_build.revision)

    title_variables[:repo] = current_repo.full_name
    title_variables[:name] = @file.path
  end
end
