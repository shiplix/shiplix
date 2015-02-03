require 'cocaine'

class ScmUpdateService
  pattr_initialize :build

  def call
    Cocaine::CommandLine.logger = Logger.new(STDOUT)

    check
    release
  end

  private

  def check
    if File.exist?(build.locator.cache_path.join('HEAD').to_s)
      update
    else
      clone
    end
  end

  def clone
    make_cache_path unless File.directory?(build.locator.cache_path.to_s)

    Cocaine::CommandLine.
      new('git', 'clone --mirror :url :path').
      run(url: build.repo.scm_url, path: build.locator.cache_path.to_s)
  end

  def update
    Cocaine::CommandLine.
      new('cd', ':cache_path && git remote set-url origin :url').
      run(cache_path: build.locator.cache_path.to_s, url: build.repo.scm_url)

    Cocaine::CommandLine.
      new('cd', ':cache_path && git remote update').
      run(cache_path: build.locator.cache_path.to_s)
  end

  def release
    make_revision_path unless File.directory?(build.locator.revision_path.to_s)

    Cocaine::CommandLine.
      new('cd', ':cache_path && git archive :revision | tar -x -f - -C :revision_path').
      run(revision: build.revision,
          cache_path: build.locator.cache_path.to_s,
          revision_path: build.locator.revision_path.to_s)
  end

  def make_cache_path
    Cocaine::CommandLine.
      new('mkdir', '-p :path').
      run(path: build.locator.cache_path.to_s)
  end

  def make_revision_path
    Cocaine::CommandLine.
      new('mkdir', '-p :path').
      run(path: build.locator.revision_path.to_s)
  end
end
