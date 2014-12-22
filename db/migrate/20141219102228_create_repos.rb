class CreateRepos < ActiveRecord::Migration
  def change
    create_table :repos do |t|
      t.integer :github_id, null: false
      t.boolean :active, default: false, null: false
      t.integer :hook_id
      t.string :full_github_name, null: false
      t.boolean :private, null: false, default: false
      t.boolean :in_organization, null: false, default: false
      t.timestamps
    end

    add_index :repos, :active
    add_index :repos, :github_id, unique: true
  end
end
