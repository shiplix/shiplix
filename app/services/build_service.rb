require 'cocaine'

class BuildService
  pattr_initialize :repo, :revision

  def call
    @build = repo.builds.find_or_create_by!(revision: revision)

    deploy
    analyze
  end

  private

  def deploy
    line = Cocaine::CommandLine.new('bundle', 'exec', 'cap', 'build', 'deploy',
                                    environment: {'REVISON' => revision, 'REPO_NAME' => repo.full_github_name},
                                    logger: Logger.new(STDOUT))
    line.run
  end

  def analyze

  end
end
