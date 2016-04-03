class BuildLocator
  EMPTY_STRING = "".freeze

  pattr_initialize :build
  delegate :path, to: 'build.repo', prefix: :repo

  def cache_path
    @cache_path ||= repo_path.join('repo')
  end

  def revision_path
    @revision_path ||= repo_path.join(build.revision)
  end

  def revision_dir
    @revision_dir ||= revision_path.to_s + "/"
  end

  def relative_path(full_path)
    full_path.sub(revision_dir, EMPTY_STRING)
  end
end
