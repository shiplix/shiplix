class BuildsComparisonService
  pattr_initialize :target, :source

  def call
    if target.branch.repo_id != source.branch.repo_id
      raise 'Builds should be in same repo'
    end

    process_klasses
  end

  protected

  def process_klasses
    build_id = target.id
    subject_type = 'Klass'

    Klass.each_row_by_sql(changed_klasses_sql) do |row|
      Changeset.create!(build_id: build_id,
                        subject_type: subject_type,
                        subject_id: row['klass_id'],
                        rating: row['rating'],
                        prev_rating: row['prev_rating'])
    end
  end

  def changed_klasses_sql
    t_k = Klass.arel_table
    s_k = Klass.arel_table.alias(:s_klasses)

    t_k.
      join(s_k, Arel::Nodes::OuterJoin).
      on(
        t_k[:name].eq(s_k[:name]).
          and(s_k[:build_id].eq source.id)
      ).
      where(t_k[:build_id].eq target.id).
      where(
        s_k[:id].eq(nil).
          or(t_k[:rating].not_eq s_k[:rating])
      ).
      project(t_k[:id].as('klass_id'),
              t_k[:rating],
              s_k[:rating].as('prev_rating')).
      to_sql
  end
end
