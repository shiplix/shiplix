class ChangesetsFinder
  pattr_initialize :branch, [:period, :limit] do
    @period ||= 3.month.ago..Time.current
    @limit = 500
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

  private

  def find_changesets
    @changesets = branch.
      changesets.
      preload(:block, :prev_block).
      joins(:block).
      where(blocks: {type: "Blocks::Namespace"}).
      where(created_at: @period).
      order(created_at: :desc).
      limit(@limit).
      to_a
  end
end
