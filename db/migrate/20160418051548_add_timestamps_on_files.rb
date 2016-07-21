class AddTimestampsOnFiles < ActiveRecord::Migration
  def change
    change_table(:files) do |t|
      t.timestamps
    end

    add_index :files, [:branch_id, :updated_at]
  end
end
