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

  def activate?
    return false unless manage?
    return true if repo.public?

    owner = repo.owner

    return false if owner.subscription.nil? || Time.current > owner.subscription.active_till

    limit = repo.owner.plan_or_free.repo_limit
    repo.owner.active_private_repos_count < limit
  end
end
