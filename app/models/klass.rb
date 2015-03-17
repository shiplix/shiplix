class Klass < ActiveRecord::Base
  attr_accessor :metric

  has_many :metrics, class_name: '::KlassMetric'
  has_many :smells, as: :subject
  has_many :klass_source_files
  has_many :source_files, through: :klass_source_files
  belongs_to :repo

  validates :repo_id, presence: true
  validates :name, presence: true

  scope :in_build, ->(build) { joins(:metrics).where(klass_metrics: {build_id: build.id}) }
end
