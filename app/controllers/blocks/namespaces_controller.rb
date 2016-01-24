module Blocks
  class NamespacesController < ApplicationController
    include CurrentBuildable

    def show
      title_variables[:repo] = current_repo.full_github_name

      @namespace = current_build.namespaces.find_by!(name: params.require(:id))

      title_variables[:name] = @namespace.name

      @namespace.files.each do |file|
        file.content = api.file_contents(current_repo.full_github_name,
                                         file.name,
                                         current_build.revision)
      end
    end

    private

    def authenticate
      authorize current_repo, :show?
    end
  end
end
