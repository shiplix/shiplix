class Smell < ActiveRecord::Base
  belongs_to :smell
  belongs_to :source_file
  has_many :locations

  validates :smell_id, presence: true
  validates :source_file_id, presence: true
  validates :type, presence: true
end
