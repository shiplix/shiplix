class AddHeadTimestampOnBuilds < ActiveRecord::Migration
  def up
    add_column :builds, :head_timestamp, :datetime
    Build.update_all('head_timestamp = created_at')
    change_column :builds, :head_timestamp, :datetime, null: false
    add_index :builds, :head_timestamp
  end

  def down
    remove_column :builds, :head_timestamp
  end
end
