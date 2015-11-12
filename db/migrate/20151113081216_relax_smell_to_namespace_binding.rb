class RelaxSmellToNamespaceBinding < ActiveRecord::Migration
  def change
    change_column_null :smells, :namespace_id, true
  end
end
