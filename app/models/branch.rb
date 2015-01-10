class Branch < ActiveRecord::Base
  validates :repo_id, presence: true
  validates :name, presence: true
  validates :default, uniqueness: {scope: :repo_id}, if: :default?

  belongs_to :repo

  has_many :builds, dependent: :destroy
  delegate :push_builds, :pull_request_builds, to: :builds
end
