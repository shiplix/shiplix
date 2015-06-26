class AddBranchIdOnChangesets < ActiveRecord::Migration
  def up
    add_column :changesets, :branch_id, :integer

    execute <<-SQL
      update changesets
      set branch_id = builds.branch_id
      from builds
      where builds.id = changesets.build_id
    SQL

    change_column_null :changesets, :branch_id, false
    add_index :changesets, [:branch_id, :created_at]
    add_foreign_key :changesets, :branches, dependent: :delete
  end

  def down
    remove_column :changesets, :branch_id
  end
end
