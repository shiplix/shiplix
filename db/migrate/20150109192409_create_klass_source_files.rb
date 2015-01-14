class CreateKlassSourceFiles < ActiveRecord::Migration
  def change
    create_table :klass_source_files do |t|
      t.integer :klass_id, null: false
      t.integer :source_file_id, null: false
      t.integer :line, null: false
      t.integer :line_end, null: false
    end

    add_index :klass_source_files, [:klass_id, :source_file_id], unique: true

    add_index :klass_source_files,
              [:source_file_id, :line, :line_end],
              name: 'index_klass_files_on_source_file_id_and_line_and_line_end'

    add_foreign_key :klass_source_files, :klasses, dependent: :delete
    add_foreign_key :klass_source_files, :source_files, dependent: :delete
  end
end
