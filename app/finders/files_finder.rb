class FilesFinder
  include Findit::Collections
  include Findit::WillPaginate

  attr_initialize :branch, [:page, :per_page!]

  cache_key { [@branch, @page, @per_page] }

  private

  def find
    @branch.
      files.
      order("files.grade desc, files.path asc").
      paginate(page: @page || 1, per_page: @per_page)
  end
end
