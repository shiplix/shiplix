class BuildPath
  pattr_initialize :build

  def base
    @root ||= Pathname.new(ENV.fetch('SHIPLIX_BUILDS_PATH'))
  end

  def repo
    @repo ||= base.join(build.repo.full_github_name)
  end

  def cache
    @cache||= repo.join('repo')
  end

  def revision
    @revision ||= repo.join(build.revision)
  end
end
