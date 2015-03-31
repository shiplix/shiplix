class SourceFile < ActiveRecord::Base
  include Metricable

  has_many :metrics, class_name: '::SourceFileMetric'
  has_many :smells, as: :subject
  has_many :klass_source_files
  has_many :klasses, through: :klass_source_files
  belongs_to :repo

  validates :repo_id, presence: true
  validates :path, presence: true
  validates :name, presence: true

  before_validation :extract_name, unless: :name?

  scope :in_build, ->(build) { joins(:metrics).where(source_file_metrics: {build_id: build.id}) }

  def self.preload_metric(records, build)
    ActiveRecord::Associations::Preloader.new.
      preload(records, :metrics, SourceFileMetric.where(build_id: build.id))
  end

  protected

  def extract_name
    return if path.blank?

    self.name = Pathname.new(path).basename.to_s
  end
end
