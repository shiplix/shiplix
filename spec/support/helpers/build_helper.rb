module BuildHelper
  # Stub build with path to repo
  #
  # Example:
  #   stub_build(create(:push), 'reek')
  def stub_build(build, repo_path)
    repo_path = Pathname.new(fixture_path).join(repo_path)
    allow(build.locator).to receive(:revision_path).and_return(repo_path)
  end
end
