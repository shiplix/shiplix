class BuildsComparisonService
  pattr_initialize :target, :source

  def call
    if target.branch.repo_id != source.branch.repo_id
      raise 'Builds should be in same repo'
    end

    process(Klass, :name)
    process(SourceFile, :path)
  end

  protected

  def process(subject, unique_field)
    subject.each_row_by_sql(changes_query(subject, unique_field).to_sql) do |row|
      Changeset.create!(build_id: target.id,
                        subject_type: subject.name,
                        subject_id: row['id'],
                        rating: row['rating'],
                        prev_rating: row['prev_rating'])
    end
  end

  def changes_query(subject, unique_field)
    t = subject.arel_table
    s = t.alias(:source)

    t.
      join(s, Arel::Nodes::OuterJoin).
      on(
        t[unique_field].eq(s[unique_field]).
          and(s[:build_id].eq source.id)
      ).
      where(t[:build_id].eq target.id).
      where(
        s[:id].eq(nil).
          or(t[:rating].not_eq s[:rating])
      ).
      project(t[:id],
              t[:rating],
              s[:rating].as('prev_rating'))
  end
end
