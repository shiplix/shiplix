class AddSmellTraitColumn < ActiveRecord::Migration
  def change
    add_column :smells, :trait, :string
  end
end
