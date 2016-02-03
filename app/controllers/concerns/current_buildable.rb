module CurrentBuildable
  def current_owner
    @owner ||= Owner.find_by!(name: params.require(:owner_id))
  end

  def current_repo
    @repo ||= current_owner.repos.active.find_by!(name: params.require(:repo_id))
  end

  def current_branch
    @current_branch ||= current_repo.branches.find_by!(name: params.require(:branch_id))
  end

  def current_build
    return @build if defined?(@build)

    build = if params[:branch_id]
              current_branch.try(:recent_push_build)
            else
              build = Build.find_by!(uid: params.require(:build_id))
            end

    build = nil if build && build.repo != current_repo
    @build = build
  end
end
