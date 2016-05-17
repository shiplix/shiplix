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

crumb :profile do
  link "Profile", profile_root_url
end

crumb :billing do
  link "Billing", profile_billing_index_url
  parent :profile
end

crumb :payment do |owner|
  link "Subscription for #{owner.name}", new_profile_billing_subscription_url(owner)
  parent :billing
end
