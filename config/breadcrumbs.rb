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

crumb :blocks do |repo, build, branch|
  url = if build
          repo_build_blocks_url(repo.owner, repo, build)
        elsif branch
          repo_branch_blocks_url(repo.owner, repo, branch)
        end

  link 'Code', url if url
  parent :repo, repo
end

crumb :namespace do |repo, namespace|
  link namespace.name, repo_build_namespace_url(repo.owner, repo, namespace.build, namespace)
  parent :blocks, repo, namespace.build, nil
end

crumb :file do |repo, file|
  link file.name, repo_build_file_url(repo.owner, repo, file.build, file)
  parent :blocks, repo, file.build, nil
end
