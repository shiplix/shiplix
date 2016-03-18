class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :name, null: false
      t.boolean :active, null: false, default: true
      t.integer :months, null: false, default: 1
      t.decimal :price, null: false, precision: 8, scale: 2
      t.integer :repo_limit, null: false
      t.timestamps null: false
    end
    add_index :plans, :name, unique: true


    add_column :owners, :plan_id, :integer
    add_index :owners, :plan_id
    add_foreign_key :owners, :plans, on_delete: :restrict

    create_table :accounts do |t|
      t.integer :owner_id, null: false
      t.integer :plan_id, null: false
      t.string :uid, null: false, limit: 32
      t.decimal :price, null: false, precision: 8, scale: 2
      t.boolean :paid, null: false, default: false
      t.date :paid_till
      t.timestamps null: false
    end

    add_index :accounts, :uid, unique: true
    add_index :accounts, :plan_id
    add_index :accounts, [:owner_id, :paid, :paid_till]
    add_foreign_key :accounts, :owners, on_delete: :cascade
    add_foreign_key :accounts, :plans, on_delete: :restrict
  end
end
