module Blocks
  class FilesController < ApplicationController
    include CurrentBuildable

    def show
      authorize current_repo, :show?
      
      title_variables[:repo] = current_repo.full_name

      @file = current_build.files.find_by!(name: params.require(:id))

      title_variables[:name] = @file.name

      @file.content = api.file_contents(current_repo.full_name,
                                        @file.name,
                                        current_build.revision)
    end
  end
end
