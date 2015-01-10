class CreateSourceFiles < ActiveRecord::Migration
  def change
    create_table :source_files do |t|
      t.integer :build_id, null: false
      t.string :path, null: false, limit: 2048
      t.string :name, null: false
      t.integer :rating
      t.integer :complexity

      t.timestamps
    end

    add_index :source_files, [:build_id, :path], unique: true

    add_foreign_key :source_files, :builds, dependent: :delete
  end
end
