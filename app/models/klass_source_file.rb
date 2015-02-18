class KlassSourceFile < ActiveRecord::Base
  belongs_to :klass
  belongs_to :source_file

  validates :klass_id, presence: true
  validates :source_file_id, presence: true

  scope :by_path, -> (path) { joins(:source_file).where('source_files.path': path).first }
end
