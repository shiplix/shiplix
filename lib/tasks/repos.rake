namespace :repos do
  task clean: :environment do
    not_active_repos = Repo.joins(branches: :builds)
      .where("builds.updated_at <= '#{30.days.ago}'")
      .where.not('builds.state' => :pending)
    RepoCleanService.new(not_active_repos).call if not_active_repos.present?
  end
end
