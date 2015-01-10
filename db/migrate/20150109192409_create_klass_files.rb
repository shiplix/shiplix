class CreateKlassFiles < ActiveRecord::Migration
  def change
    create_table :klass_source_files do |t|
      t.integer :klass_id, null: false
      t.integer :source_file_id, null: false
    end

    add_index :klass_source_files, [:klass_id, :source_file_id], unique: true
    add_index :klass_source_files, [:source_file_id]

    add_foreign_key :klass_source_files, :klasses, dependent: :delete
    add_foreign_key :klass_source_files, :source_files, dependent: :delete
  end
end
