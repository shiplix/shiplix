class Block < ActiveRecord::Base
  belongs_to :build
  has_many :smells

  validates :build, presence: true
  validates :name, presence: true
  validates :rating, numericality: {greater_than_or_equal_to: 1, less_than_or_equal_to: 5}

  def increment_metric(name, by = 1)
    metrics[name] = metrics.fetch(name, 0) + by
  end

  def to_param
    name
  end

  # Smells grouped by categories with statistics
  #
  # Returns Hash {smell_type => count}
  #
  # TODO: move to finders?
  def smells_statistics
    @smells_statistics ||= smells.each_with_object({}) do |smell, memo|
      memo[smell.type] = memo[smell.type].to_i + 1
    end.sort_by { |key, _| ::Smell::IMPORTANCE.index(key) }
  end
end
