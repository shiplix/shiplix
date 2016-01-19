module Blocks
  class FilesController < ApplicationController
    before_action only: [:show] { title_variables[:repo] = repo.full_github_name }

    def show
      return render_error(404) unless build
      title_variables[:name] = file.name

      file.content = api.file_contents(repo.full_github_name,
                                       file.name,
                                       build.revision)
    end

    private

    def repo
      @repo ||= Repo.active.find_by!(full_github_name: params[:repo_id])
    end

    def build
      @build ||= repo.default_branch.try(:recent_push_build)
    end

    def namespace
      @namespace ||= build.namespaces.find_by!(name: params[:id])
    end

    def file
      @file ||= build.files.find_by!(name: params[:id])
    end
  end
end
