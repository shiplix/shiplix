class ChangeUniqueIndexOnChangesets < ActiveRecord::Migration
  def up
    remove_index :changesets, name: 'index_changesets_on_build_id'
    add_index :changesets, [:build_id, :subject_type, :subject_id], unique: true
  end

  def down
    remove_index :changesets, name: 'index_changesets_on_build_id_and_subject_type_and_subject_id'
    add_index :changesets, :build_id, unique: true
  end
end
