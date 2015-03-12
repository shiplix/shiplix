class CreateChangesets < ActiveRecord::Migration
  def change
    create_table :changesets do |t|
      t.integer :build_id, null: false
      t.column :subject_type, 'smell_subject_type', null: false
      t.integer :subject_id, null: false
      t.integer :rating
      t.integer :prev_rating
      t.timestamps null: false
    end

    add_index :changesets, :build_id, unique: true
    add_index :changesets, [:subject_type, :subject_id]

    add_foreign_key :changesets, :builds, dependent: :delete
  end
end
