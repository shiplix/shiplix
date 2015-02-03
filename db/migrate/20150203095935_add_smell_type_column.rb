class AddSmellTypeColumn < ActiveRecord::Migration
  def change
    add_column :smells, :smell_type, :string
  end
end
