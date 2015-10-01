module Ratingable
  extend ActiveSupport::Concern

  included do
    validates :rating_smells_count, numericality: {only_integer: true, greater_than_or_equal_to: 0}
    validates :total_rating, numericality: {only_integer: true, greater_than_or_equal_to: 0}
    validates :rating, numericality: {only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 5}

    before_save :compute_rating
  end

  private

  def compute_rating
    return if rating_smells_count.to_i.zero?

    self.rating = (total_rating / rating_smells_count.to_f).round
  end
end
