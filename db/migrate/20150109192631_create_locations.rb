class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.integer :smell_id, null: false
      t.integer :source_file_id, null: false
      t.integer :line, null: false
      t.integer :num_lines, null: false, default: 0
    end

    add_index :locations, :smell_id
    add_index :locations, :source_file_id

    add_foreign_key :locations, :smells, dependent: :delete
    add_foreign_key :locations, :source_files, dependent: :delete
  end
end
