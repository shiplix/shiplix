class CreateBuildsEnums < ActiveRecord::Migration
  def up
    execute %q{create type build_type as enum ('Builds::Push', 'Builds::PullRequest')}
    execute %q{create type build_state as enum ('pending', 'finished', 'failed')}
  end

  def down
    execute %q{drop type build_type}
    execute %q{drop type build_state}
  end
end
