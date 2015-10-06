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

    create_enum :block_type, "Blocks::File", "Blocks::Namespace"

    create_table :blocks do |t|
      t.integer :build_id, null: false,
        index: {with: [:type, :name], unique: true},
        foreign_key: {on_delete: :cascade}
      t.column :type, :block_type, null: false
      t.string :name, null: false, limit: 2048
      t.jsonb :metrics, null: false, default: '{}'
      t.integer :rating, null: false, default: 1
      t.integer :smells_count, null: false, default: 0
    end

    create_table :locations do |t|
      t.integer :namespace_id, null: false,
        index: {with: [:file_id]},
        foreign_key: {references: :blocks, on_delete: :cascade}
      t.integer :file_id, null: false,
        index: true,
        foreign_key: {references: :blocks, on_delete: :cascade}
      t.int4range :position, null: false
    end

    create_table :smells do |t|
      t.integer :namespace_id, null: false,
        index: {with: [:file_id]},
        foreign_key: {references: :blocks, on_delete: :cascade}
      t.integer :file_id, null: false,
        index: true,
        foreign_key: {references: :blocks, on_delete: :cascade}
      t.column :type, :smell_type, null: false
      t.string :message, limit: 1024
      t.jsonb :data, null: false, default: '{}'
      t.int4range :position, null: false
    end

    create_table :changesets do |t|
      t.integer :build_id, null: false,
        index: {with: [:block_id]},
        foreign_key: {on_delete: :cascade}
      t.integer :block_id, null: false,
        index: true,
        foreign_key: {on_delete: :cascade}
      t.integer :prev_block_id,
        index: true,
        foreign_key: {references: :blocks, on_delete: :cascade}
    end
  end

  def down
    drop_table :smells
    drop_table :locations
    drop_table :changesets
    drop_table :blocks
    drop_enum :block_type
  end
end
