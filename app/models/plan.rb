class Plan < ActiveRecord::Base
  has_many :owners

  validates :name,  presence: true
  validates :price, presence: true
  validates :months, presence: true, numericality: true
  validates :repo_limit, presence: true, numericality: true

  scope :active, ->{ where(active: true) }
end
