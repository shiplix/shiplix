class KlassMetric < ActiveRecord::Base
  include Ratingable

  belongs_to :klass
  belongs_to :build

  validates :klass_id, presence: true
  validates :build_id, presence: true

  scope :for, ->(klass_name) { joins(:klass).where(klasses: {name: klass_name}) }
end
