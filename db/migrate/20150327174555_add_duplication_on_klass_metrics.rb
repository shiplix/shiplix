class AddDuplicationOnKlassMetrics < ActiveRecord::Migration
  def change
    add_column :klass_metrics, :duplication, :integer, default: 0, null: false
  end
end
