class ChangesetsFinder
  attr_initialize :branch, [:period, :limit] do
    @period ||= 3.month.ago..Time.current
    @limit = 500
  end

  def call
    changesets = find
    group(changesets)
  end

  private

  def find
    @branch.
      changesets.
      where(builds: {state: :finished, type: "Builds::Push"}).
      where(changesets: {created_at: @period}).
      order("changesets.created_at desc").
      limit(@limit).
      to_a
  end

  def group(changesets)
    changesets = changesets.group_by { |x| x.created_at.at_beginning_of_month.to_date }

    changesets.each do |month, month_changesets|
      changesets[month] = month_changesets.group_by { |x| x.created_at.to_date }

      changesets[month].each do |date, date_changesets|
        changesets[month][date] = date_changesets.group_by { |x| x.grade_before.nil? }
      end
    end

    changesets
  end
end
