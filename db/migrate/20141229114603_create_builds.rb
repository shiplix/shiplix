class CreateBuilds < ActiveRecord::Migration
  def change
    create_table :builds do |t|
      t.integer :branch_id, null: false
      t.column :type, 'build_type', null: false
      t.string :revision, null: false, limit: 40
      t.integer :pull_request_number
      t.column :state, 'build_state', null: false

      t.timestamps
    end

    add_index :builds, [:branch_id, :pull_request_number], unique: true
    # TODO: more indexes?

    add_foreign_key :builds, :branches, dependent: :delete
  end
end
