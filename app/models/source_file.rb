class SourceFile < ActiveRecord::Base
  has_many :smells
  has_many :klass_source_files
  has_many :klasses, through: :klass_source_files
  belongs_to :build

  validates :build_id, presence: true
  validates :path, presence: true
  validates :name, presence: true

  before_validation :extract_name, unless: :name?

  def extract_name
    return if path.blank?

    self.name = Pathname.new(path).basename.to_s
  end

  def klass_by_line(line)
    klass_source_files.
      where('line <= ? and line_end >= ?', line, line).
      order(:line).
      first.
      try(:klass)
  end
end
