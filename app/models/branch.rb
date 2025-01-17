class Branch < ActiveRecord::Base
  validates :repo_id, presence: true
  validates :name, presence: true
  validates :default, uniqueness: {scope: :repo_id}, if: :default?

  belongs_to :repo

  has_many :builds, dependent: :destroy
  has_many :changesets, through: :builds
  has_many :files, class_name: "SourceFile"

  delegate :push_builds, :pull_request_builds, to: :builds
  has_one :recent_push_build, -> { where(state: 'finished').order(head_timestamp: :desc) }, class_name: 'Builds::Push'

  def to_param
    name
  end
end
