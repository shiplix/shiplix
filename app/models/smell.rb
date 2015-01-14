class Smell < ActiveRecord::Base
  belongs_to :klass
  belongs_to :source_file
  has_many :locations

  validates :klass_id, presence: true
  validates :source_file_id, presence: true
  validates :type, presence: true
end
