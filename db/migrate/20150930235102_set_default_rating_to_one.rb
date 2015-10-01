class SetDefaultRatingToOne < ActiveRecord::Migration
  def up
    change_column_default :builds, :rating, 1
    change_column_default :klass_metrics, :rating, 1
    change_column_default :source_file_metrics, :rating, 1
  end

  def down
    change_column_default :builds, :rating, 0
    change_column_default :klass_metrics, :rating, 0
    change_column_default :source_file_metrics, :rating, 0
  end
end
