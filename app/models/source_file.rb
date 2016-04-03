class SourceFile < ActiveRecord::Base
  self.table_name = "files"

  attr_accessor :content

  belongs_to :branch
  has_many :smells, foreign_key: :file_id

  validates :branch, presence: true
  validates :path, presence: true

  def to_param
    path
  end

  # Smells grouped by categories with statistics
  #
  # Returns Hash {smell_type => count}
  #
  # TODO: move to finders?
  def smells_statistics
    @smells_statistics ||= smells.each_with_object(Hash.new(0)) do |smell, memo|
      memo[smell.analyzer] += 1
    end
  end
end
