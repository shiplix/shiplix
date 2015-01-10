class CreateSmellsEnums < ActiveRecord::Migration
  def up
    execute %q{create type smell_type as enum ('Smells::Flog')}
  end

  def down
    execute %q{drop type smell_type}
  end
end
