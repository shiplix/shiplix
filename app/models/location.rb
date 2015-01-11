class Location < ActiveRecord::Base
  belongs_to :smell
  belongs_to :source_file

  validates :smell_id, presence: true
  validates :source_file_id, presence: true
  validates :line, presence: true
end
