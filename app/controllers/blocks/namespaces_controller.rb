module Blocks
  class NamespacesController < ApplicationController
    include CurrentBuildable

    def show
      authorize current_repo, :show?
      
      title_variables[:repo] = current_repo.full_name

      @namespace = current_build.namespaces.find_by!(name: params.require(:id))

      title_variables[:name] = @namespace.name

      @namespace.files.each do |file|
        file.content = api.file_contents(current_repo.full_name,
                                         file.name,
                                         current_build.revision)
      end
    end
  end
end
