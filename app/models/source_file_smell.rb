class SourceFileSmell < ActiveRecord::Base
  belongs_to :source_file
  belongs_to :smell

  validates :source_file_id, presence: true
  validates :smell_id, presence: true
end
