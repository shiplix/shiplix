class AddLocToKlassSource < ActiveRecord::Migration
  def change
    add_column :klass_source_files, :loc, :integer, default: 0
  end
end
