class AddPayloadDataOnBuilds < ActiveRecord::Migration
  def change
    add_column :builds, :payload_data, :text, null: false
  end
end
