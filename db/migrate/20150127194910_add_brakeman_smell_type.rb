class AddBrakemanSmellType < ActiveRecord::Migration
  self.disable_ddl_transaction!

  def up
    execute "ALTER TYPE smell_type ADD VALUE 'Smells::Brakeman' AFTER 'Smells::Rubocop';"
  end

  def down
    #no-op
  end
end
