class RepoPolicy
  pattr_initialize :user, :repo

  def manage?
    if user.memberships.loaded?
      !!user.memberships.detect { |membership| membership.repo_id == repo.id }.try(:admin?)
    else
      !!user.memberships.find_by(repo_id: repo.id).try(:admin?)
    end
  end

  def show?
    return true unless repo.private?
    user.present? && user.memberships.where(repo_id: repo.id).exists?
  end
end
