class ScmCleanService
  include CommandLineable

  pattr_initialize :build

  def call
    cmd('rm', '-rf :revision_path').
      run(revision_path: build.locator.revision_path.to_s)
  end
end
