class Smell < ActiveRecord::Base
  belongs_to :build
  belongs_to :subject, polymorphic: true
  has_many :locations

  validates :build_id, presence: true
  validates :subject_id, presence: true
  validates :subject_type, presence: true
  validates :type, presence: true

  before_create :increment_smells
  before_create :increment_total_rating, if: :rating

  def rating
    nil
  end

  private

  def increment_smells
    subject.metric.increment(:smells_count) if subject.metric
    build.increment(:smells_count)
  end

  def increment_total_rating
    if subject.metric
      subject.metric.increment(:rating_smells_count)
      subject.metric.increment(:total_rating, rating)
    end

    build.increment(:rating_smells_count)
    build.increment(:total_rating, rating)
  end
end
