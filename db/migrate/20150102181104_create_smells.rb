class CreateSmells < ActiveRecord::Migration
  def change
    create_table :smells do |t|
      t.integer :build_id, null: false
      t.column :type, 'smell_type', null: false
      t.string :message
      t.integer :score
      t.string :method_name

      t.timestamps
    end

    add_index :smells, :type
    add_index :smells, :build_id

    add_foreign_key :smells, :builds, dependent: :delete


    create_table :source_file_smells do |t|
      t.integer :source_file_id, null: false
      t.integer :smell_id, null: false
    end

    add_index :source_file_smells, [:source_file_id, :smell_id], unique: true
    add_index :source_file_smells, [:smell_id]

    add_foreign_key :source_file_smells, :source_files, dependent: :delete
    add_foreign_key :source_file_smells, :smells, dependent: :delete


    create_table :klass_smells do |t|
      t.integer :klass_id, null: false
      t.integer :smell_id, null: false
    end

    add_index :klass_smells, [:klass_id, :smell_id], unique: true
    add_index :klass_smells, [:smell_id]

    add_foreign_key :klass_smells, :klasses, dependent: :delete
    add_foreign_key :klass_smells, :smells, dependent: :delete
  end
end
