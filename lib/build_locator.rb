class BuildLocator
  pattr_initialize :build

  def base_path
    @root ||= Pathname.new(ENV.fetch('SHIPLIX_BUILDS_PATH'))
  end

  def repo_path
    @repo ||= base_path.join(build.repo.full_github_name)
  end

  def cache_path
    @cache||= repo_path.join('repo')
  end

  def revision_path
    @revision ||= repo_path.join(build.revision)
  end

  def relative_path(path)
    @revision_path ||= revision_path.to_s + '/'
    path.sub(@revision_path, '')
  end
end
