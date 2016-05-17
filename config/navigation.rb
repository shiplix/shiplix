SimpleNavigation::Configuration.run do |navigation|
  navigation.autogenerate_item_ids = false

  navigation.items do |primary|
    if current_repo
      primary.item(:repos,
                   'Go to dashboard',
                   repos_url,
                   html: {icon: 'fa-desktop'})

      primary.item(:repo,
                   current_repo.full_name,
                   repo_path(current_repo.owner, current_repo),
                   html: {icon: 'fa-pencil'})

      if branch = current_repo.default_branch
        primary.item(:files,
                     'Source Files',
                     repo_branch_files_path(current_repo.owner, current_repo, branch),
                     highlights_on: %r{/repos/.*?/.*?/branches/.*?/files},
                     html: {icon: 'fa-file-text-o'})
      end
    else
      primary.item(:repos,
                   'Repositories',
                   repos_url,
                   html: {icon: 'fa-desktop'})
    end

    primary.item(:profile, 'Profile Settings', profile_root_path, html: {icon: 'fa-user'})
  end
end
