require 'cocaine'

class PushBuildService
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
      build.finish!
    end
  rescue Exception
    build.fail! if build.present?
    raise
  end

  private

  def create_build
    branch.push_builds.where(revision: revision).first.try(:destroy)
    @build = Builds::Push.create!(branch: branch, revision: revision)
  end

  def update
    ScmUpdateService.new(build).call
  end

  def analyze
    ANALYZERS.each { |analyzer| analyzer.new(build).call }
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
