class Location < ActiveRecord::Base
  belongs_to :smell

  validates :smell_id, presence: true
  validates :line, presence: true
  validates :path, presence: true
end
