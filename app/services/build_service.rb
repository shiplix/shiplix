require 'cocaine'

class BuildService
  pattr_initialize :repo, :revision

  def call
    @build = repo.builds.find_or_create_by!(revision: revision)

    pull
    analyze
  end

  private

  def pull
    PullService.new(repo, revision).call
  end

  def analyze
    AnalyzeService.new(repo, revision).call
  end
end
