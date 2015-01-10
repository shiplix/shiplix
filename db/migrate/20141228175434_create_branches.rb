class CreateBranches < ActiveRecord::Migration
  def change
    create_table :branches do |t|
      t.integer :repo_id, null: false
      t.string :name, null: false
      t.boolean :default, null: false, default: false

      t.timestamps
    end

    add_index :branches, [:repo_id, :name], unique: true

    add_foreign_key :branches, :repos, dependent: :delete
  end
end
