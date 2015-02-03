class RemoveDeployKeyIdOnRepos < ActiveRecord::Migration
  def change
    remove_column :repos, :deploy_key_id
  end
end
