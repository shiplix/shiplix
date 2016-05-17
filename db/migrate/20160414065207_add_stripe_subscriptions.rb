class AddStripeSubscriptions < ActiveRecord::Migration
  def change
    add_column :owners, :stripe_customer_id, :string

    rename_table :accounts, :subscriptions
    rename_column :subscriptions, :paid_till, :active_till
    remove_column :subscriptions, :paid, :boolean, null: false, default: false
    add_column :subscriptions, :stripe_subscription_id, :string, null: false

    reversible do |dir|
      dir.up do
        change_column :subscriptions, :active_till, :datetime, null: false
      end

      dir.down do
        change_column :subscriptions, :active_till, :date
      end
    end

    remove_column :owners, :plan_id, :integer
  end
end
