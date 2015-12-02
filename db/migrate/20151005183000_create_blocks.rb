class CreateBlocks < ActiveRecord::Migration
  def up
    drop_table :locations, if_exists: true
    drop_table :smells, if_exists: true
    drop_table :klass_source_files, if_exists: true
    drop_table :klass_metrics, if_exists: true
    drop_table :source_file_metrics, if_exists: true
    drop_table :klasses, if_exists: true
    drop_table :source_files, if_exists: true
    drop_table :changesets, if_exists: true

    remove_column :builds, :total_rating, if_exists: true
    remove_column :builds, :rating_smells_count, if_exists: true

    execute "truncate builds cascade"

    execute "CREATE TYPE block_type AS ENUM ('Blocks::File', 'Blocks::Namespace')"

    create_table :blocks do |t|
      t.integer :build_id, null: false
      t.column :type, :block_type, null: false
      t.string :name, null: false, limit: 2048
      t.jsonb :metrics, null: false, default: '{}'
      t.integer :rating, null: false, default: 1
      t.integer :smells_count, null: false, default: 0
    end

    add_index :blocks, [:build_id, :type, :name], unique: true
    add_foreign_key :blocks, :builds, on_delete: :cascade

    create_table :locations do |t|
      t.integer :namespace_id, null: false
      t.integer :file_id, null: false, index: true
      t.int4range :position, null: false
    end

    add_index :locations, [:namespace_id, :file_id]
    add_foreign_key :locations, :blocks, column: :namespace_id, on_delete: :cascade
    add_foreign_key :locations, :blocks, column: :file_id, on_delete: :cascade

    create_table :smells do |t|
      t.integer :namespace_id, null: false
      t.integer :file_id, null: false, index: true
      t.column :type, :smell_type, null: false
      t.string :message, limit: 1024
      t.jsonb :data, null: false, default: '{}'
      t.int4range :position, null: false
    end

    add_index :smells, [:namespace_id, :file_id]
    add_foreign_key :smells, :blocks, column: :namespace_id, on_delete: :cascade
    add_foreign_key :smells, :blocks, column: :file_id, on_delete: :cascade

    create_table :changesets do |t|
      t.integer :build_id, null: false
      t.integer :block_id, null: false, index: true
      t.integer :prev_block_id, index: true
    end

    add_index :changesets, [:build_id, :block_id]
    add_foreign_key :changesets, :builds, on_delete: :cascade
    add_foreign_key :changesets, :blocks, column: :block_id, on_delete: :cascade
    add_foreign_key :changesets, :blocks, column: :prev_block_id, on_delete: :cascade
  end

  def down
    drop_table :smells
    drop_table :locations
    drop_table :changesets
    drop_table :blocks
    drop_enum :block_type
  end
end
