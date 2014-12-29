class CreateBuilds < ActiveRecord::Migration
  def change
    create_table :builds do |t|
      t.integer :repo_id, null: false
      t.string :revision, null: false
      t.integer :pull_request_id
    end

    add_index :builds, :repo_id

    add_foreign_key :builds, :repos, dependent: :delete_all

    add_foreign_key :memberships, :users, dependent: :delete_all
    add_foreign_key :memberships, :repos, dependent: :delete_all
  end
end
