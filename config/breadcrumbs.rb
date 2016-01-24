crumb :root do
  link 'Home', root_path
end

crumb :repos do
  link 'Repositories', repos_path
end

crumb :repo do |repo|
  link repo.full_github_name, repo_path(repo)
  parent :repos
end

crumb :blocks do |repo, build|
  link 'Code', repo_build_blocks_path(repo, build)
  parent :repo, repo
end

crumb :namespace do |repo, namespace|
  link namespace.name, repo_build_namespace_path(repo, namespace.build, namespace)
  parent :blocks, repo, namespace.build
end

crumb :file do |repo, file|
  link file.name, repo_build_file_path(repo, file.build, file)
  parent :blocks, repo, file.build
end
