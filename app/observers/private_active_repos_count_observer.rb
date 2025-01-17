# Observer for calculate private active repos for owner.
class PrivateActiveReposCountObserver < ActiveRecord::Observer
  observe Repo

  # change owner.active_private_repos_count counter
  # when private repo became active or became public
  def after_save(repo)
    if private_became_active?(repo) || active_became_private?(repo)
      repo.owner.increment!(:active_private_repos_count)
    elsif private_became_not_active?(repo) || private_became_pubic?(repo)
      repo.owner.decrement!(:active_private_repos_count)
    end
  end

  private

  def private_became_active?(repo)
    repo.private? && repo.active? && repo.active_was == false
  end

  def private_became_not_active?(repo)
    repo.private? && repo.active_was == true && repo.active == false
  end

  def private_became_pubic?(repo)
    repo.private_was == true && repo.private == false
  end

  def active_became_private?(repo)
    repo.active? && repo.private_was == false && repo.private?
  end
end
