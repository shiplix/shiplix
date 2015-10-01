class SourceFileMetric < ActiveRecord::Base
  include Ratingable

  belongs_to :source_file
  belongs_to :build

  validates :source_file_id, presence: true
  validates :build_id, presence: true
end
