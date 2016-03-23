class AddCountReposToUser < ActiveRecord::Migration
  def change
    add_column :owners, :active_private_repos_count, :integer, default: 0

    reversible do |dir|
      dir.up do
        execute <<-SQL
          UPDATE repos SET active = false;
        SQL
      end
    end
  end
end
