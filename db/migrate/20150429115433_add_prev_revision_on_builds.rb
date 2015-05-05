class AddPrevRevisionOnBuilds < ActiveRecord::Migration
  def up
    add_column :builds, :prev_revision, :string

    Build.delete_all
  end

  def down
    remove_column :builds, :prev_revision
  end
end
