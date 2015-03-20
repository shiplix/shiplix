class SourceFileMetric < ActiveRecord::Base
  include Metricable

  belongs_to :source_file
  belongs_to :build

  validates :source_file_id, presence: true
  validates :build_id, presence: true
  validates :rating, numericality: {only_integer: true, greater_than: 0, less_than: 6}
end