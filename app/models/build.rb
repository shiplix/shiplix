class Build < ActiveRecord::Base
  has_many :changesets

  belongs_to :branch

  validates :branch_id, presence: true
  validates :type, presence: true
  validates :revision, presence: true
  validates :head_timestamp, presence: true
  validates :payload_data, presence: true

  scope :push_builds, -> { where(type: 'Builds::Push') }
  scope :pull_request_builds, -> { where(type: 'Builds::PullRequest') }
  scope :recent, -> { where(state: 'finished').order(head_timestamp: :desc) }

  delegate :repo, to: :branch
  delegate :revision_path, :relative_path, to: :locator

  include AASM

  aasm column: :state do
    state :pending, initial: true
    state :finished
    state :failed

    event :finish do
      transitions from: :pending, to: :finished
    end

    event :fail do
      transitions from: :pending, to: :failed
    end
  end

  def prev_build
    @prev_build ||= self.class.where(branch_id: branch.id, revision: prev_revision).first
  end

  def repo_config
    @repo_config ||= RepoConfig.new(locator.revision_path.join("shiplix.yml").to_s)
  end

  def locator
    @locator ||= BuildLocator.new(self)
  end

  def source_locator
    @source_locator ||= SourceLocator.new(locator.revision_path, repo_config[:paths])
  end

  def collections
    @collections ||= BuildCollections.new(self)
  end
end
