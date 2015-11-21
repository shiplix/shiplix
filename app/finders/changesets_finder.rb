class ChangesetsFinder
  pattr_initialize :branch, [:period] do
    @period ||= 3.month.ago..Time.now
  end

  attr_reader :changesets

  def call
    find_changesets

    @changesets = @changesets.
      group_by { |x| x.created_at.at_beginning_of_month.to_date }

    @changesets.each do |month, changesets|
      @changesets[month] = changesets.group_by { |x| x.created_at.to_date }
      @changesets[month].each do |date, changesets|
        @changesets[month][date] = changesets.group_by { |x| x.prev_block_id.nil? }
      end
    end

    @changesets
  end

  protected

  def find_changesets
    @changesets = branch.
      changesets.
      includes(:block).
      where(created_at: period).
      order(created_at: :desc).
      to_a
  end
end
