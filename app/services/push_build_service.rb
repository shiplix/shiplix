require 'cocaine'

class PushBuildService < ApplicationService
  pattr_initialize :branch, :payload

  attr_reader :build

  ANALYZERS = [
    Analyzers::NamespacesService,
    Analyzers::FlogService,
    Analyzers::FlayService,
    Analyzers::ReekService,
    Analyzers::BrakemanService
  ]

  # Returns Builds::Push
  def call
    create_build
    update_scm

    transaction do
      analyze # TODO: long transaction!, move outside of block if has no write queries
      build.collections.save
      build.finish!
    end

    compare_builds

    build
  rescue Exception
    build.fail! if build.present? && build.may_fail?
    raise
  ensure
    scm_clean if build.present?
  end

  private

  def create_build
    branch.push_builds.find_by(revision: payload.revision).try(:destroy)

    @build = Builds::Push.create!(branch: branch, payload: payload)
  end

  def update_scm
    ScmUpdateService.new(build).call
  end

  def analyze
    ANALYZERS.each { |analyzer| analyzer.new(build).call }
  end

  def compare_builds
    return unless build.prev_build
    PushBuildsComparisonJob.enqueue(build.id, build.prev_build.id)
  end

  def scm_clean
    ScmCleanService.new(build).call
  end

  def transaction
    inner_exception = nil

    build.transaction do
      begin
        yield
      rescue ActiveRecord::Rollback => e
        inner_exception = e
        raise
      end
    end

    raise inner_exception if inner_exception
  end
end
