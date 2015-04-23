class Klass < ActiveRecord::Base
  include Metricable

  IMPORTANCE_OF_SMELLS = %w(Smells::Flog Smells::Flay Smells::Reek Smells::Brakeman).freeze

  has_many :metrics, class_name: '::KlassMetric'
  has_many :smells, as: :subject
  has_many :klass_source_files
  has_many :source_files, through: :klass_source_files
  belongs_to :repo

  validates :repo_id, presence: true
  validates :name, presence: true

  scope :in_build, ->(build) { joins(:metrics).where(klass_metrics: {build_id: build.id}) }

  def source_file_in_build(build, path)
    source_files.where(klass_source_files: {build_id: build.id},
                       path: path)
  end

  def to_param
    name
  end

  # Smells grouped by categories with statistics
  #
  # Returns Hash {smell_type => count}
  def smells_statistics
    @smells_statistics ||= smells.each_with_object({}) do |smell, memo|
      memo[smell.type] = memo[smell.type].to_i + 1
    end.sort_by { |key, _| IMPORTANCE_OF_SMELLS.index(key) }
  end
end
