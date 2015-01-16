class CreateSmellsEnums < ActiveRecord::Migration
  def up
    execute <<-SQL
      create type smell_type as enum ('Smells::Flog', 'Smells::Flay', 'Smells::Reek', 'Smells::Rubocop');
      create type smell_subject_type as enum ('Klass', 'SourceFile')
    SQL
  end

  def down
    execute <<-SQL
      drop type smell_type;
      drop type smell_subject_type
    SQL
  end
end
