class ChangeRatingTypeOnBuilds < ActiveRecord::Migration
  def change
    change_column :builds, :rating, :decimal, precision: 3, scale: 2
  end
end
