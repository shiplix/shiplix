class CreateDocuments < ActiveRecord::Migration
  def up
    execute "truncate builds cascade"

    drop_table :locations

    remove_column :builds, :rating
    remove_column :blocks, :rating
    remove_column :blocks, :type
    remove_column :changesets, :block_id
    remove_column :changesets, :prev_block_id
    remove_column :smells, :namespace_id
    remove_column :smells, :file_id

    drop_enum :block_type

    rename_table :blocks, :documents

    execute "create type grade_type AS ENUM ('A', 'B', 'C', 'D', 'F')"

    add_column :builds, :grade, "grade_type", null: false, default: "A"
    add_column :documents, :grade, "grade_type", null: false, default: "A"
    add_column :changesets, :document_id, :integer, null: false
    add_column :changesets, :prev_document_id, :integer
    add_column :smells, :document_id, :integer

    add_index :changesets, :document_id
    add_index :changesets, :prev_document_id
    add_index :changesets, [:build_id, :document_id]
    add_index :documents, [:build_id, :name], unique: true
    add_index :smells, :document_id

    add_foreign_key :changesets, :documents, on_delete: :cascade
    add_foreign_key :changesets, :documents, on_delete: :cascade
    add_foreign_key :changesets, :documents, column: :prev_document_id, on_delete: :cascade
    add_foreign_key :smells, :documents, on_delete: :cascade
  end
end
