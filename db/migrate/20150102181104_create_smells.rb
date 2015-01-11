class CreateSmells < ActiveRecord::Migration
  def change
    create_table :smells do |t|
      t.integer :klass_id, null: false
      t.integer :source_file_id, null: false
      t.column :type, 'smell_type', null: false
      t.string :message
      t.integer :score
      t.string :method_name

      t.timestamps
    end

    add_index :smells, :type
    add_index :smells, :klass_id
    add_index :smells, :source_file_id

    add_foreign_key :smells, :klasses, dependent: :delete
    add_foreign_key :smells, :source_files, dependent: :delete
  end
end
