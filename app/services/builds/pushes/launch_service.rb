module Builds
  module Pushes
    class LaunchService < ApplicationService
      pattr_initialize :repo, :payload

      attr_reader :branch, :build

      def call
        find_branch
        create_build
        update_scm
        analyze
        build.finish!
        #compare_builds
      rescue Exception => e
        begin
          build.fail! if build.present? && build.may_fail?
        rescue Exception => e
          puts "Failed to fail build, #{e.message}"
        end

        raise e
      ensure
        scm_clean if build.present?
      end

      private

      def create_build
        branch.push_builds.find_by(revision: payload.revision).try(:destroy)

        @build = Builds::Push.create!(branch: branch, payload: payload)
      end

      def find_branch
        BranchesSyncService.new(repo).call
        @branch = repo.branches.find_by!(name: payload.branch)
      end

      def update_scm
        ScmUpdateService.new(build).call
      end

      def scm_clean
        ScmCleanService.new(build).call
      end

      def analyze
        AnalyzeService.new(build).call
      end

      def compare_builds
        return unless build.prev_build
        Builds::Pushes::ComparisonJob.enqueue(build.id, build.prev_build.id)
      end
    end
  end
end
