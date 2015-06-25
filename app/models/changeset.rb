class Changeset < ActiveRecord::Base
  belongs_to :branch
  belongs_to :build
  belongs_to :subject, polymorphic: true

  validates :build_id, presence: true
  validates :subject_id, presence: true
  validates :subject_type, presence: true

  before_create { self.branch ||= build.branch }
end
