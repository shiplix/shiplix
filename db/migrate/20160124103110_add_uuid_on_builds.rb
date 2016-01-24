class AddUuidOnBuilds < ActiveRecord::Migration
  def up
    add_column :builds, :uid, :string, limit: 32

    execute <<-SQL
      update builds set uid = md5(random()::text) where uid is null
    SQL

    change_column_null :builds, :uid, false

    add_index :builds, :uid, unique: true
  end

  def down
    remove_column :builds, :uid
  end
end
