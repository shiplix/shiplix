class CreateFiles < ActiveRecord::Migration
  def up
    execute "truncate builds cascade"

    drop_table :locations

    remove_column :builds, :rating
    remove_column :builds, :uid

    remove_column :blocks, :build_id
    remove_column :blocks, :type
    remove_column :blocks, :rating
    remove_column :blocks, :name

    remove_column :changesets, :block_id
    remove_column :changesets, :prev_block_id
    remove_column :changesets, :build_id

    remove_column :smells, :namespace_id
    remove_column :smells, :file_id
    remove_column :smells, :type

    execute "drop type block_type"
    execute "drop type smell_type"

    rename_table :blocks, :files

    execute "create type analyzer_name AS ENUM ('flog', 'flay', 'reek', 'brakeman')"
    execute "create type grade_type AS ENUM ('A', 'B', 'C', 'D', 'F')"

    add_column :builds, :gpa, :decimal, precision: 2, scale: 1
    add_column :builds, :files_count, :integer, null: false, default: 0

    add_column :files, :branch_id, :integer, null: false
    add_column :files, :path, :string, null: false, limit: 1024
    add_column :files, :grade, "grade_type", null: false, default: "A"
    add_column :files, :pain, :integer, null: false, default: 0
    add_index :files, [:branch_id, :path], unique: true
    add_index :files, [:branch_id, :pain]
    add_foreign_key :files, :branches, on_delete: :cascade

    add_column :changesets, :build_id, :integer, null: false
    add_column :changesets, :path, :string, limit: 1024, null: false
    add_column :changesets, :grade_after, "grade_type", null: false
    add_column :changesets, :grade_before, "grade_type"
    add_index :changesets, [:build_id, :created_at]
    add_foreign_key :changesets, :builds, on_delete: :cascade

    add_column :smells, :file_id, :integer, null: false
    add_column :smells, :analyzer, "analyzer_name", null: false
    add_column :smells, :check_name, :string, null: false
    add_column :smells, :pain, :integer, null: false, default: 0
    add_column :smells, :fingerprint, :string, null: false, limit: 32
    add_index :smells, [:file_id, :fingerprint]
    add_foreign_key :smells, :files, on_delete: :cascade
  end
end
