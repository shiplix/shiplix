require 'cocaine'

class ScmUpdateService < ApplicationService
  include CommandLineable

  pattr_initialize :build

  def call
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

    cmd('git', 'clone --mirror :url :path').
      run(url: build.repo.scm_url, path: build.locator.cache_path.to_s)
  end

  def update
    cmd('cd', ':cache_path && git remote set-url origin :url').
      run(cache_path: build.locator.cache_path.to_s, url: build.repo.scm_url)

    cmd('cd', ':cache_path && git remote update').
      run(cache_path: build.locator.cache_path.to_s)
  end

  def release
    make_revision_path unless File.directory?(build.locator.revision_path.to_s)

    cmd('cd', ':cache_path && git archive :revision | tar -x -f - -C :revision_path').
      run(revision: build.revision,
          cache_path: build.locator.cache_path.to_s,
          revision_path: build.locator.revision_path.to_s)
  end

  def make_cache_path
    cmd('mkdir', '-p :path').
      run(path: build.locator.cache_path.to_s)
  end

  def make_revision_path
    cmd('mkdir', '-p :path').
      run(path: build.locator.revision_path.to_s)
  end
end
