module Metricable
  extend ActiveSupport::Concern

  included do
    attr_accessor :total_rating

    before_save :calc_rating
  end

  protected

  def calc_rating
    return if smells_count.to_i.zero?

    self.rating = (total_rating / smells_count.to_f).round
  end
end
