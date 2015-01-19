class SourceLocator
  RUBY_EXTENSION = '.rb'.freeze
  RUBY_FILES = File.join("**", "*#{RUBY_EXTENSION}")

  # creates SourceLocator which find paths to source ruby files
  #
  # paths - String or Array of path to root build or porject folder
  def initialize(paths)
    @initial_paths = Array.wrap(paths)
  end

  # Public: array of paths to ruby files in repo
  #
  # Returns Array
  def paths
    @paths ||= pathnames.map(&:to_s)
  end

  # Public: array of Pathname instances to ruby files in repo
  #
  # Returns Array
  def pathnames
    @pathnames ||= expand_paths
  end

  private

  def expand_paths
    @initial_paths.flat_map do |path|
      if File.directory?(path)
        Pathname.glob(File.join(path, RUBY_FILES))
      elsif File.exist?(path) && File.extname(path) == RUBY_EXTENSION
        Pathname.new(path)
      end
    end.compact.map(&:cleanpath)
  end
end
