module BuildHelper
  # Stub build with path to repo
  #
  # Example:
  #   stub_build(create(:push), fixture_path('reek'))
  def stub_build(build, path_to_folder_or_file)
    allow(build).to receive(:source_locator)
      .and_return(SourceLocator.new(path_to_folder_or_file))

    allow(build).to receive(:revision_path).and_return path_to_repo_files(path_to_folder_or_file)
  end

  def path_to_repo_files(path)
    Pathname.new(fixture_path).join(path)
  end

  def stub_env
    stub_const('ENV', {'SHIPLIX_BUILDS_PATH' => fixture_path})
    stub_const('ENV', {'SHIPLIX_GITHUB_CLIENT_ID' => '111'})
    stub_const('ENV', {'SHIPLIX_GITHUB_CLIENT_SECRET' => '222'})
  end
end
