class SourceLocator
  # creates SourceLocator which find paths to source ruby files
  #
  # root_path - Pathname
  # paths - String or Array of path to root build or porject folder
  def initialize(root_path, paths)
    @root_path = Pathname.new(root_path)
    @initial_paths = Array.wrap(paths)
  end

  # Public: array of paths to ruby files in repo
  #
  # Returns Array
  def paths
    @paths ||= pathnames.map(&:to_s)
  end

  private

  # Private: array of Pathname instances to ruby files in repo
  #
  # Returns Array
  def pathnames
    @pathnames ||= expand_paths
  end

  def expand_paths
    @initial_paths.
      flat_map { |path| Pathname.glob(@root_path.join(path)) }.
      compact.map(&:cleanpath)
  end
end
