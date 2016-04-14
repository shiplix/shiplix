class FilesController < ApplicationController
  def index
    authorize current_repo, :show?

    title_variables[:repo] = current_repo.full_name

    return unless current_branch
    @files = current_branch.
               files.
               order("files.pain desc, files.path asc").
               paginate(page: params[:page], per_page: 20)
  end

  def show
    authorize current_repo, :show?

    title_variables[:repo] = current_repo.full_name

    @file = current_branch.files.find_by!(path: params.require(:id))

    title_variables[:name] = @file.path

    @file.content = api.file_contents(current_repo.full_name,
                                      @file.path,
                                      current_branch.recent_push_build.revision)
  end
end
