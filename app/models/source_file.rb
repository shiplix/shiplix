class SourceFile < ActiveRecord::Base
  attr_accessor :metric

  has_many :metrics, class_name: '::SourceFileMetric'
  has_many :smells, as: :subject
  has_many :klass_source_files
  has_many :klasses, through: :klass_source_files
  belongs_to :repo

  validates :repo_id, presence: true
  validates :path, presence: true
  validates :name, presence: true

  before_validation :extract_name, unless: :name?

  scope :in_build, ->(build) { joins(:metrics).where(metrics: {build_id: build.id}) }

  protected

  def extract_name
    return if path.blank?

    self.name = Pathname.new(path).basename.to_s
  end
end
