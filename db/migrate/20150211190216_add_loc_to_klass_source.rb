class AddLocToKlassSource < ActiveRecord::Migration
  def change
    add_column :klass_source_files, :loc, :integer, default: 0
    add_column :source_files, :loc, :integer, default: 0
    add_column :klasses, :loc, :integer, default: 0
  end
end
