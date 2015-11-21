module Builds
  module Pushes
    class ComparisonService < ApplicationService
      pattr_initialize :target, :source

      def call
        if target.branch.repo_id != source.branch.repo_id
          raise 'Builds should be in same repo'
        end

        target.transaction do
          ActiveRecord::Base.each_row_by_sql(changes_query.to_sql) do |row|
            Changeset.create!(build_id: target.id,
                              block_id: row['block_id'],
                              prev_block_id: row['prev_block_id'])
          end
        end
      end

      private

      def changes_query
        t = Block.arel_table
        s = t.alias(:source)

        t.
          join(s, Arel::Nodes::OuterJoin).
          on(
            s[:build_id].eq(source.id)
            .and(s['type'].eq(t['type']))
          ).
          where(t[:build_id].eq target.id).
          where(
            s[:id].eq(nil).
              or(t[:rating].not_eq s[:rating])
          ).
          project(t[:id].as('block_id'),
                  s[:id].as('prev_block_id'))

      end
    end
  end
end
