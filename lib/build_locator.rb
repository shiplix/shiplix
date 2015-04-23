class BuildLocator
  pattr_initialize :build
  delegate :path, to: 'build.repo', prefix: :repo

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
