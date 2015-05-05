module Builds
  module Pushes
    class ComparisonJob < ApplicationJob
      include Retryable
      extend Resque::Single

      @queue = :medium

      lock_on { |target_id, source_id| [target_id, source_id] }

      def self.execute(target_id, source_id)
        target = Build.find(target_id)
        source = Build.find(source_id)

        ComparisonService.new(target, source).call
      end
    end
  end
end
