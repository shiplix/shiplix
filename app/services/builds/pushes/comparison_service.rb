module Builds
  module Pushes
    class ComparisonService < ApplicationService
      attr_initialize :target, :source

      def call
        if @target.branch.repo_id != @source.branch.repo_id
          raise 'Builds should be in same repo'
        end

        @target.transaction do
          ActiveRecord::Base.each_row_by_sql(changes_query) do |row|
            Changeset.create!(build_id: @target.id,
                              block_id: row['block_id'],
                              prev_block_id: row['prev_block_id'])
          end
        end
      end

      private

      def changes_query
        sql = <<-SQL.strip_heredoc
          select target.id as block_id, source.id as prev_block_id
          from blocks as target
          left join blocks as source on source.build_id = %{source_id}
            and source.type = target.type
            and source.name = target.name
          where target.build_id = %{target_id}
            and (
              source.id is null
              or round(target.rating) != round(source.rating)
            )
        SQL

        sql % {source_id: @source.id, target_id: @target.id}
      end
    end
  end
end
