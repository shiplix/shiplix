class KlassMetric < ActiveRecord::Base
  include Metricable

  belongs_to :klass
  belongs_to :build

  validates :klass_id, presence: true
  validates :build_id, presence: true
  validates :rating, numericality: {only_integer: true, greater_than: 0, less_than: 6}

  scope :for, ->(klass_name) { joins(:klass).where(klasses: {name: klass_name}) }
end