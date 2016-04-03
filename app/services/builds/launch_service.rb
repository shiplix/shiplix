module Builds
  class LaunchService < ApplicationService
    pattr_initialize :repo, :payload

    attr_reader :branch, :build

    def call
      find_branch
      create_build
      update_scm
      analyze
      grade
      save
      build.finish!
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

    def grade
      GradeService.new(build).call
    end

    def save
      SaveService.new(build).call
    end
  end
end
