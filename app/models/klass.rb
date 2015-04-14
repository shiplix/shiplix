class Klass < ActiveRecord::Base
  include Metricable

  has_many :metrics, class_name: '::KlassMetric'
  has_many :smells, as: :subject
  has_many :klass_source_files
  has_many :source_files, through: :klass_source_files
  belongs_to :repo

  validates :repo_id, presence: true
  validates :name, presence: true

  scope :in_build, ->(build) { joins(:metrics).where(klass_metrics: {build_id: build.id}) }

  def self.preload_metric(records, build)
    ActiveRecord::Associations::Preloader.new.
      preload(records, :metrics, KlassMetric.where(build_id: build.id))
  end

  def self.preload_smells(records, build)
    ActiveRecord::Associations::Preloader.new.
      preload(records, :smells, Smell.where(build_id: build.id))
  end

  def self.preload_source_files(records, build)
    ActiveRecord::Associations::Preloader.new.
      preload(records, :klass_source_files, KlassSourceFile.where(build_id: build.id))

    ksf = Array.wrap(records).flat_map(&:klass_source_files)
    ActiveRecord::Associations::Preloader.new.preload(ksf, :source_file)
  end

  def source_file_in_build(build, path)
    source_files.where(klass_source_files: {build_id: build.id},
                       path: path)
  end

  def to_param
    name
  end
end
