class CreateSmells < ActiveRecord::Migration
  def change
    create_table :smells do |t|
      t.integer :build_id, null: false
      t.integer :subject_id, null: false
      t.column :subject_type, 'smell_subject_type', null: false
      t.column :type, 'smell_type', null: false
      t.string :message
      t.integer :score
      t.string :method_name

      t.timestamps
    end

    add_index :smells, [:build_id, :type]
    add_index :smells, [:subject_id, :subject_type]

    add_foreign_key :smells, :builds, dependent: :delete
  end
end
