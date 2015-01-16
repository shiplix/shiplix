class Klass < ActiveRecord::Base
  has_many :smells, as: :subject
  has_many :klass_source_files
  has_many :source_files, through: :klass_source_files
  belongs_to :build

  validates :build_id, presence: true
  validates :name, presence: true
end
