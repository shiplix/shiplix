class AddCreatedAtToChangesets < ActiveRecord::Migration
  def change
    add_column :changesets, :created_at, :datetime, null: false
    add_index :changesets, :created_at
  end
end
