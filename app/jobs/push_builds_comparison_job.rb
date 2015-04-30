class PushBuildsComparisonJob < ApplicationJob
  include Retryable
  extend Resque::Single

  @queue = :medium

  lock_on { |target_id, source_id| [target_id, source_id] }

  def self.execute(target_id, source_id)
    target = Build.find(target_id)
    source = Build.find(source_id)

    PushBuildsComparisonService.new(target, source).call
  end
end
