class AddSmellsCount < ActiveRecord::Migration
  def change
    add_column :klasses, :smells_count, :integer, default: 0
    add_column :source_files, :smells_count, :integer, default: 0
    add_column :builds, :smells_count, :integer, default: 0
  end
end
