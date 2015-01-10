class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :github_username, null: false
      t.string :remember_token, null: false
      t.boolean :refreshing_repos, default: false
      t.string :email_address
      t.string :access_token, null: false

      t.timestamps null: false
    end

    add_index :users, :remember_token
  end
end
