class SourceLocator
  RUBY_EXTENSION = '.rb'.freeze
  RUBY_FILES = File.join("**", "*#{RUBY_EXTENSION}")

  def initialize(paths)
    @initial_paths = Array.wrap(paths)
  end

  def paths
    @paths ||= pathnames.map(&:to_s)
  end

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
