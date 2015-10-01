class AddRatingSmellsCount < ActiveRecord::Migration
  def up
    add_column :builds, :rating, :integer, null: false, default: 1
    add_column :builds, :total_rating, :integer, null: false, default: 0
    add_column :builds, :rating_smells_count, :integer, null: false, default: 0

    add_column :klass_metrics, :total_rating, :integer, null: false, default: 0
    add_column :klass_metrics, :rating_smells_count, :integer, null: false, default: 0

    add_column :source_file_metrics, :total_rating, :integer, null: false, default: 0
    add_column :source_file_metrics, :rating_smells_count, :integer, null: false, default: 0
  end

  def down
    remove_column :builds, :rating
    remove_column :builds, :total_rating
    remove_column :builds, :rating_smells_count

    remove_column :klass_metrics, :total_rating
    remove_column :klass_metrics, :rating_smells_count

    remove_column :source_file_metrics, :total_rating
    remove_column :source_file_metrics, :rating_smells_count
  end
end
