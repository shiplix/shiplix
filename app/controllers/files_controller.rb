class FilesController < ApplicationController
  def index
    return not_found unless current_repo
    authorize current_repo, :show?

    title_variables[:repo] = current_repo.full_name

    @files = current_branch && current_branch.
               files.
               order("files.pain desc, files.path asc").
               paginate(page: params[:page], per_page: 20)
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
