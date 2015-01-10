class Smell < ActiveRecord::Base
  belongs_to :build
  has_many :locations

  validates :build_id, presence: true
  validates :type, presence: true
end
