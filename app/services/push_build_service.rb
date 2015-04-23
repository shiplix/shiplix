require 'cocaine'

class PushBuildService < ApplicationService
  attr_reader :build

  pattr_initialize :branch, :revision

  ANALYZERS = [
    Analyzers::NamespacesService,
    Analyzers::FlogService,
    Analyzers::FlayService,
    Analyzers::ReekService,
    Analyzers::BrakemanService
  ]

  def call
    create_build
    update
    transaction do
      analyze
      build.collections.save
      finish_build
    end
  rescue Exception
    fail_build if build.present?
    raise
  end

  private

  def create_build
    branch.push_builds.where(revision: revision).first.try(:destroy)
    @build = Builds::Push.create!(branch: branch, revision: revision)
  end

  def fail_build
    build.fail!
    ScmCleanService.new(build).call
  end

  def finish_build
    if last_build
      BuildsComparisonService.new(build, last_build).call
      ScmCleanService.new(last_build).call
    end

    build.finish!
  end

  def update
    ScmUpdateService.new(build).call
  end

  def analyze
    ANALYZERS.each { |analyzer| analyzer.new(build).call }
  end

  def last_build
    return @last_build if @last_build
    @last_build = branch.recent_push_build
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
