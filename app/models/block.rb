class Block < ActiveRecord::Base
  attr_accessor :rating_smells_count, :total_rating

  belongs_to :build

  validates :build, presence: true
  validates :name, presence: true
  validates :rating, numericality: {only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5}

  scope :order_by_rating, ->(dir = 'ASC') { order("metrics->>'rating' #{dir}")}
  scope :order_by_smells_count, ->(dir = 'ASC') { order("metrics->>'smells_count' #{dir}")}

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
