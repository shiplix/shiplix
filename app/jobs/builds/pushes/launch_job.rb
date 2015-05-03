require 'json'

module Builds
  module Pushes
    class LaunchJob < ApplicationJob
      extend Resque::Single
      include Retryable

      @queue = :low

      lock_on do |repo_id, json|
        payload = Payload::Push.new(json)
        [repo_id, payload.branch, payload.revision]
      end

      def self.execute(repo_id, json)
        repo = Repo.find(repo_id)
        payload = Payload::Push.new(json)

        Builds::Pushes::LaunchService.new(repo, payload).call
      end
    end
  end
end
