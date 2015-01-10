class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.integer :user_id, null: false
      t.integer :repo_id, null: false
      t.boolean :owner, null: false, default: false

      t.timestamps
    end

    add_index :memberships, [:user_id, :repo_id], unique: true
    add_index :memberships, [:repo_id, :owner], where: 'owner = TRUE'

    add_foreign_key :memberships, :users, dependent: :delete
    add_foreign_key :memberships, :repos, dependent: :delete
  end
end
