class Repo < ActiveRecord::Base
  has_many :memberships
  has_many :users, through: :memberships
  has_many :branches

  alias_attribute :name, :full_github_name

  validates :full_github_name, presence: true
  validates :github_id, uniqueness: true, presence: true

  def self.active
    where(active: true)
  end

  def self.find_or_create_with(attributes)
    repo = where(github_id: attributes[:github_id]).first_or_initialize
    repo.update(attributes)
    repo
  end

  def self.find_and_update(github_id, repo_name)
    repo = find_by(github_id: github_id)

    if repo && repo.full_github_name != repo_name
      repo.update(full_github_name: repo_name)
    end

    repo
  end

  def owner
    @owner ||= memberships.where(owner: true).first.user
  end

  def activate(user)
    return if active?

    transaction do
      update(active: true)
      memberships.where(user_id: user.id).first.update(owner: true)
    end
  end

  def deactivate
    return unless active?

    transaction do
      update(active: false)
      owner.memberships.where(repo_id: id).first.update(owner: false)
      @owner = nil
    end
  end

  def scm_url
    "git@github.com:#{full_github_name}.git"
  end

  private

  def organization
    full_github_name.split("/").first if full_github_name
  end
end
