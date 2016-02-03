module Builds
  module Pushes
      class EnqueueRecentService < ApplicationService
      pattr_initialize :user, :repo, [:branch_name]

      def call
        return unless revision

        branch = repo.branches.find_by(name: branch_name)
        build = branch.push_builds.find_by(revision: revision) if branch

        if build
          payload = build.payload
        else
          payload = Payload::Push.new.tap do |payload|
            payload.revision = revision
            payload.branch = branch_name
          end
        end

        Builds::Pushes::LaunchJob.enqueue(repo.id, payload.to_json).meta_id
      end

      private

      def revision
        @revision ||= api.recent_revision(repo.full_name, branch_name)
      end

      def branch_name
        @branch_name ||= api.default_branch(repo.full_name)
      end
    end
  end
end
