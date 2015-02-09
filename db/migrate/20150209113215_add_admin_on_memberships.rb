class AddAdminOnMemberships < ActiveRecord::Migration
  def up
    add_column :memberships, :admin, :boolean
    execute 'update memberships set admin = true'
    change_column :memberships, :admin, :boolean, default: false, null: false
  end

  def down
    remove_column :memberships, :admin
  end
end
