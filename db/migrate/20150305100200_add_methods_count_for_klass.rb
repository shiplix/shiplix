class AddMethodsCountForKlass < ActiveRecord::Migration
  def change
    add_column :klasses, :methods_count, :integer, default: 0
  end
end
