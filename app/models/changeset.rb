class Changeset < ActiveRecord::Base
  belongs_to :build, required: true

  validates :path, presence: true
  validates :grade_after, presence: true
end
