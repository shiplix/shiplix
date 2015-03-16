class CreateMetrics < ActiveRecord::Migration
  def up
    create_table :klass_metrics do |t|
      t.integer :klass_id, null: false
      t.integer :build_id, null: false
      t.integer :rating, null: false, default: 1
      t.integer :complexity, null: false, default: 0
      t.integer :loc, null: false, default: 0
      t.integer :smells_count, null: false, default: 0
      t.integer :methods_count, null: false, default: 0
      t.timestamps
    end

    add_index :klass_metrics, [:klass_id, :build_id], unique: true
    add_index :klass_metrics, :build_id

    add_foreign_key :klass_metrics, :klasses, dependent: :delete
    add_foreign_key :klass_metrics, :builds, dependent: :delete

    # не стал писать сложную миграцию данных, т.к. пока не страшно терять данные
    execute 'truncate klasses cascade'
    remove_columns :klasses, :build_id, :rating, :complexity, :loc, :smells_count, :methods_count
    add_column :klasses, :repo_id, :integer, null: false
    add_index :klasses, [:repo_id, :name], unique: true
    add_foreign_key :klasses, :repos, dependent: :delete

    execute 'truncate klass_source_files cascade'
    add_column :klass_source_files, :build_id, :integer, null: false
    add_index :klass_source_files, :build_id
    remove_index :klass_source_files, name: 'index_klass_files_on_source_file_id_and_line_and_line_end'
    remove_index :klass_source_files, name: 'index_klass_source_files_on_klass_id_and_source_file_id'
    add_index :klass_source_files,
              [:source_file_id, :build_id, :line, :line_end],
              unique: true,
              name: 'index_klass_files_on_source_file_id_and_line_and_line_end'
    add_index :klass_source_files,
              [:klass_id, :source_file_id, :build_id],
              unique: true,
              name: 'index_klass_source_files_on_klass_id_and_source_file_id'


    create_table :source_file_metrics do |t|
      t.integer :source_file_id, null: false
      t.integer :build_id, null: false
      t.integer :rating, null: false, default: 1
      t.integer :loc, null: false, default: 0
      t.integer :smells_count, null: false, default: 0
      t.timestamps
    end

    add_index :source_file_metrics, [:source_file_id, :build_id], unique: true
    add_index :source_file_metrics, :build_id

    add_foreign_key :source_file_metrics, :source_files, dependent: :delete
    add_foreign_key :source_file_metrics, :builds, dependent: :delete

    execute 'truncate source_files cascade'
    remove_columns :source_files, :build_id, :rating, :complexity, :loc, :smells_count
    add_column :source_files, :repo_id, :integer, null: false
    add_index :source_files, [:repo_id, :path], unique: true
    add_foreign_key :source_files, :repos, dependent: :delete
  end

  def down
    drop_table :klass_metrics

    remove_column :klasses, :repo_id
    add_column :klasses, :build_id, null: false
    add_column :klasses, :rating, null: false, default: 1
    add_column :klasses, :complexity
    add_column :klasses, :loc, default: 0
    add_column :klasses, :smells_count, default: 0
    add_column :klasses, :methods_count, default: 0

    add_index :klasses, [:build_id, :name], unique: true

    add_foreign_key :klasses, :builds, dependent: :delete

    remove_column :klass_source_files, :build_id
    remove_index :klass_source_files, name: 'index_klass_files_on_source_file_id_and_line_and_line_end'
    remove_index :klass_source_files, name: 'index_klass_source_files_on_klass_id_and_source_file_id'
    add_index :klass_source_files,
              [:source_file_id, :line, :line_end],
              unique: true,
              name: 'index_klass_files_on_source_file_id_and_line_and_line_end'
    add_index :klass_source_files,
              [:klass_id, :source_file_id],
              unique: true,
              name: 'index_klass_source_files_on_klass_id_and_source_file_id'

    drop_table :source_file_metrics

    remove_column :source_files, :repo_id
    add_column :source_files, :build_id, null: false
    add_column :source_files, :rating, null: false, default: 1
    add_column :source_files, :complexity
    add_column :source_files, :loc, default: 0
    add_column :source_files, :smells_count, default: 0
  end
end
