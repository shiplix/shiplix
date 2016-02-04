class CreateOwners < ActiveRecord::Migration
  def up
    create_owners
    move_activated_user
    rename_full_github_name
  end

  private

  def create_owners
    execute "CREATE TYPE owner_type AS ENUM ('Owners::User', 'Owners::Org')"

    create_table :owners do |t|
      t.column :type, :owner_type, null: false
      t.string :name, null: false
      t.timestamps null: false
    end

    add_index :owners, [:name], unique: true

    execute <<-SQL
      insert into owners (type, name, created_at, updated_at)
      select
        distinct on (split_part(repos.full_github_name, '/', 1))
        case
          when in_organization then 'Owners::Org'::owner_type
          else 'Owners::User'::owner_type
        end as type,
        split_part(repos.full_github_name, '/', 1) as org_name,
        now(), now()
      from repos;
    SQL

    remove_column :repos, :in_organization

    add_column :repos, :owner_id, :integer

    execute <<-SQL
      update repos
      set owner_id = owners.id
      from owners
      where owners.name = split_part(repos.full_github_name, '/', 1);
    SQL

    add_index :repos, :owner_id

    change_column_null :repos, :owner_id, null = false

    add_foreign_key :repos, :owners, on_delete: :cascade
  end

  def move_activated_user
    add_column :repos, :activated_by, :integer

    add_index :repos, :activated_by

    add_foreign_key :repos, :users, column: :activated_by, on_delete: :nullify

    execute <<-SQL
      update repos
      set activated_by = memberships.user_id
      from memberships
      where
        repos.id = memberships.repo_id
        and memberships.owner;
    SQL
    remove_column :memberships, :owner
    add_index :memberships, :repo_id
  end

  def rename_full_github_name
    execute <<-SQL
      update repos
      set full_github_name = split_part(full_github_name, '/', 2)
    SQL

    rename_column :repos, :full_github_name, :name
  end
end
