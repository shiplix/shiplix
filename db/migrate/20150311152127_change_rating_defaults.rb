class ChangeRatingDefaults < ActiveRecord::Migration
  def up
    Changeset.where(rating: nil).update_all(rating: 1)
    change_column :changesets, :rating, :integer, null: false, default: 1

    Klass.where(rating: nil).update_all(rating: 1)
    change_column :klasses, :rating, :integer, null: false, default: 1

    SourceFile.where(rating: nil).update_all(rating: 1)
    change_column :source_files, :rating, :integer, null: false, default: 1
  end
end
