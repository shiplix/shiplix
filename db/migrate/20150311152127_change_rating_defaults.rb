class ChangeRatingDefaults < ActiveRecord::Migration
  def up
    execute 'UPDATE changesets SET rating = 1 where rating IS NULL'
    change_column :changesets, :rating, :integer, null: false, default: 1

    execute 'UPDATE klasses SET rating = 1 where rating IS NULL'
    change_column :klasses, :rating, :integer, null: false, default: 1

    execute 'UPDATE source_files SET rating = 1 where rating IS NULL'
    change_column :source_files, :rating, :integer, null: false, default: 1
  end
end
