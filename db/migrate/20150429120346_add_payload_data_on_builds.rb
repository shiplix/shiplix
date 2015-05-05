class AddPayloadDataOnBuilds < ActiveRecord::Migration
  def up
    Build.delete_all
    add_column :builds, :payload_data, :json, null: false
  end

  def down
    remove_column :builds, :payload_data
  end
end
