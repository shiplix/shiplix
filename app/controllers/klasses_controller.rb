class KlassesController < ApplicationController
  add_breadcrumb 'Home', :root_path
  add_breadcrumb 'Repositories', :repos_path

  def index
    add_breadcrumb "Classes #{repo.full_github_name}", :repo_klasses_path
    self.title_variables = {repo: repo.full_github_name}

    @klasses = build.klasses.paginate(page: params[:page], per_page: 20) if build.present?
  end

  private

  def repo
    @repo ||= current_user.repos.active.find(params[:repo_id])
  end

  def branch
    @branch ||= repo.branches.find_by!(default: true)
  end

  def build
    @build ||= branch.push_builds.recent.first
  end
end
