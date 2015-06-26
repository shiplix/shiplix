module Builds
  module Pushes
    class ComparisonService < ApplicationService
      pattr_initialize :target, :source

      def call
        if target.branch.repo_id != source.branch.repo_id
          raise 'Builds should be in same repo'
        end

        target.transaction do
          process(KlassMetric, :klass_id, 'Klass')
          process(SourceFileMetric, :source_file_id, 'SourceFile')
        end
      end

      protected

      def process(subject, field, type)
        subject.each_row_by_sql(changes_query(subject, field).to_sql) do |row|
          Changeset.create!(build_id: target.id,
                            branch_id: target.branch_id,
                            subject_type: type,
                            subject_id: row['subject_id'],
                            rating: row['rating'],
                            prev_rating: row['prev_rating'])
        end
      end

      def changes_query(subject, field)
        t = subject.arel_table
        s = t.alias(:source)

        t.
          join(s, Arel::Nodes::OuterJoin).
          on(
            t[field].eq(s[field]).
              and(s[:build_id].eq source.id)
          ).
          where(t[:build_id].eq target.id).
          where(
            s[:id].eq(nil).
              or(t[:rating].not_eq s[:rating])
          ).
          project(t[field].as('subject_id'),
                  t[:rating],
                  s[:rating].as('prev_rating'))
      end
    end
  end
end
