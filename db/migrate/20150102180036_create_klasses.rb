class CreateKlasses < ActiveRecord::Migration
  def change
    create_table :klasses do |t|
      t.integer :build_id, null: false
      t.string :name, null: false
      t.integer :rating
      t.integer :complexity

      t.timestamps
    end

    add_index :klasses, [:build_id, :name], unique: true

    add_foreign_key :klasses, :builds, dependent: :delete
  end
end
