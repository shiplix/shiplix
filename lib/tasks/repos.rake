namespace :repos do
  desc "Recreate hooks for all repos which has hook"
  task recreate_hooks: :environment do
    Repo.where.not(hook_id: nil).find_each do |repo|
      api = GithubApi.new(repo.owner.access_token)
      api.remove_hooks(repo.full_github_name, repo.hook_id)

      api.add_hooks(repo.full_github_name, GithubApi::CALLBACK_ENDPOINT) do |hook_id|
        repo.update(hook_id: hook_id)
      end
    end
  end

  task clean: :environment do
    not_active_repos = Repo.joins(branches: :builds)
      .where("builds.updated_at <= '#{30.days.ago}'")
      .where.not('builds.state' => :pending)
    RepoCleanService.new(not_active_repos).call if not_active_repos.present?
  end
end
