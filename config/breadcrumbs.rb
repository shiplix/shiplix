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

crumb :blocks do |repo|
  link 'Classes & files', repo_blocks_path(repo)
  parent :repo, repo
end

crumb :namespace do |repo, namespace|
  link namespace.name, repo_namespace_path(repo, namespace)
  parent :blocks, repo
end

crumb :file do |repo, file|
  link file.name, repo_file_path(repo, file)
  parent :blocks, repo
end
