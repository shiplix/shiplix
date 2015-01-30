class AddDeployKeyIdOnRepos < ActiveRecord::Migration
  def change
    add_column :repos, :deploy_key_id, :integer
  end
end
