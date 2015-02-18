class Smell < ActiveRecord::Base
  belongs_to :build
  belongs_to :subject, polymorphic: true
  has_many :locations

  validates :build_id, presence: true
  validates :subject_id, presence: true
  validates :subject_type, presence: true
  validates :type, presence: true

  after_create :increment_counters

  def increment_counters
    subject.increment(:smells_count)
    build.increment(:smells_count)
  end
end
