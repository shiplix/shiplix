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

crumb :klasses do |repo|
  link 'Classes', repo_klasses_path(repo)
  parent :repo, repo
end

crumb :klass do |repo, klass|
  link klass.name, repo_klass_path(repo, klass)
  parent :klasses, repo
end

crumb :source_files do |repo|
  link 'Source files', repo_source_files_path(repo)
  parent :repo, repo
end
