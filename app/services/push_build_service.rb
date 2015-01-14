require 'cocaine'

class PushBuildService
  attr_reader :build

  pattr_initialize :branch, :revision

  ANALYZERS = [
    Analyzers::NamespacesService,
    Analyzers::FlogService
  ]

  def call
    create_build
    update
    build.transaction do
      analyze
    end

    build.finish!
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
end
