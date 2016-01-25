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

crumb :blocks do |repo, build, branch|
  url = if build
          repo_build_blocks_path(repo, build)
        elsif branch
          repo_branch_blocks_path(repo, branch)
        end

  link 'Code', url if url
  parent :repo, repo
end

crumb :namespace do |repo, namespace|
  link namespace.name, repo_build_namespace_path(repo, namespace.build, namespace)
  parent :blocks, repo, namespace.build, nil
end

crumb :file do |repo, file|
  link file.name, repo_build_file_path(repo, file.build, file)
  parent :blocks, repo, file.build, nil
end
