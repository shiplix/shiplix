# Service for remove source from file storage
class RepoCleanService
  include CommandLineable

  def initialize(repos)
    repos = Array.wrap(repos)
    @paths = repos.map { |repo| repo.path.to_s }
  end

  def call
    cmd('rm -rf', ':paths').run(paths: @paths)
  end
end
