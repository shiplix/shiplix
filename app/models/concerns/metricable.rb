module Metricable
  extend ActiveSupport::Concern

  included do
    attr_writer :metric
  end

  def metric
    return @metric if defined?(@metric)
    metrics[0] if metrics.loaded?
  end
end
