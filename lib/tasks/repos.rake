namespace :repos do
  desc "Recreate hooks for all repos which has hook"
  task recreate_hooks: :environment do
    Repo.where.not(hook_id: nil).find_each do |repo|
      api = GithubApi.new(repo.activator.access_token)
      api.remove_hooks(repo.full_name, repo.hook_id)

      api.add_hooks(repo.full_name, GithubApi::CALLBACK_ENDPOINT) do |hook_id|
        repo.update(hook_id: hook_id)
      end
    end
  end

  task clean: :environment do
    if (low_activity_repos = Repo.low_activity.to_a).present?
      RepoCleanService.new(low_activity_repos).call
    end
  end
end
