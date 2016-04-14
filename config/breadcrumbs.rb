crumb :root do
  link 'Home', root_url
end

crumb :repos do
  link 'Repositories', repos_url
end

crumb :repo do |repo|
  link repo.full_name, repo_url(repo.owner, repo)
  parent :repos
end

crumb :files do |repo, branch|
  link 'Files', repo_branch_files_url(repo.owner, repo, branch)
  parent :repo, repo
end

crumb :file do |repo, file|
  link file.path, repo_branch_file_url(repo.owner, repo, file.branch, file)
  parent :files, repo, file.branch
end
