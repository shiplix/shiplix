class Repo < ActiveRecord::Base
  BASE_PATH = Pathname.new(ENV.fetch('SHIPLIX_BUILDS_PATH'))

  belongs_to :owner
  belongs_to :activator, class_name: "User", foreign_key: :activated_by
  has_many :memberships
  has_many :users, through: :memberships
  has_many :branches
  has_one :default_branch, -> { where(default: true) }, class_name: 'Branch'

  validates :name, presence: true
  validates :owner, presence: true
  validates :github_id, uniqueness: true, presence: true

  scope :low_activity, -> do
    joins(branches: :builds)
      .where("builds.updated_at <= '#{30.days.ago}'")
      .where.not('builds.state' => :pending)
  end

  def self.active(value = true)
    where(active: value)
  end

  def self.find_or_create_with(attributes)
    repo = where(github_id: attributes[:github_id]).first_or_initialize
    repo.update(attributes)
    repo
  end

  def full_name
    @full_name ||= "#{owner.name}/#{name}"
  end

  def activate(user)
    update(active: true, activator: user) unless active?
  end

  def deactivate
    update(active: false, activator: nil) if active?
  end

  def scm_url
    "https://#{activator.access_token}:@github.com/#{full_name}.git"
  end

  def path
    @path ||= BASE_PATH.join(full_name)
  end

  def to_param
    name
  end

  def public?
    !private?
  end
end
