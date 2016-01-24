module Blocks
  class FilesController < ApplicationController
    include CurrentBuildable

    def show
      title_variables[:repo] = current_repo.full_github_name

      @file = current_build.files.find_by!(name: params.require(:id))

      title_variables[:name] = @file.name

      @file.content = api.file_contents(current_repo.full_github_name,
                                        @file.name,
                                        current_build.revision)
    end

    private

    def authenticate
      authorize current_repo, :show?
    end
  end
end
