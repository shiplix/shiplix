class Build < ActiveRecord::Base
  has_many :klasses
  has_many :source_files
  has_many :smells

  belongs_to :branch

  validates :branch_id, presence: true
  validates :type, presence: true
  validates :revision, presence: true

  scope :push_builds, -> { where(type: 'Builds::Push') }
  scope :pull_request_builds, -> { where(type: 'Builds::PullRequest') }
  scope :recent, -> { where(state: 'finished').order(id: :desc) }

  delegate :repo, to: :branch

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

  def locator
    @locator ||= BuildLocator.new(self)
  end

  def source_locator
    return @source_locator if @source_locator

    paths = %w(app lib config spec).map { |dir| locator.revision_path.join(dir).to_s }
    @source_locator = SourceLocator.new(paths)
  end
end
