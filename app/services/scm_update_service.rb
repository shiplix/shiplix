require 'build_path'
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
    if File.exist?(build_path.cache.join('HEAD').to_s)
      update
    else
      clone
    end
  end

  def clone
    make_cache_path unless File.directory?(build_path.cache.to_s)

    Cocaine::CommandLine.
      new('git', 'clone --mirror :url :path').
      run(url: build.repo.scm_url, path: build_path.cache.to_s)
  end

  def update
    Cocaine::CommandLine.
      new('git', 'remote update').
      run
  end

  def release
    make_revision_path unless File.directory?(build_path.revision.to_s)

    Cocaine::CommandLine.
      new('cd', ':cache_path && git archive :revision | tar -x -f - -C :revision_path').
      run(revision: build.revision,
          cache_path: build_path.cache.to_s,
          revision_path: build_path.revision.to_s)
  end

  def make_cache_path
    Cocaine::CommandLine.
      new('mkdir', '-p :path').
      run(path: build_path.cache.to_s)
  end

  def make_revision_path
    Cocaine::CommandLine.
      new('mkdir', '-p :path').
      run(path: build_path.revision.to_s)
  end

  def build_path
    @build_path ||= BuildPath.new(build)
  end
end
