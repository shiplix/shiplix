class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.integer :smell_id, null: false
      t.integer :line, null: false
      t.integer :num_lines, null: false, default: 0
      t.string :path, null: false, limit: 2048
    end

    add_index :locations, :smell_id

    add_foreign_key :locations, :smells, dependent: :delete
  end
end
