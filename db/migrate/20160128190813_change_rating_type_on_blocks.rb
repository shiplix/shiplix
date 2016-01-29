class ChangeRatingTypeOnBlocks < ActiveRecord::Migration
  def change
    change_column :blocks, :rating, :decimal, precision: 3, scale: 2
  end
end
