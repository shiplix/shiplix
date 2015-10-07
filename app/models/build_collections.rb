class BuildCollections
  attr_reader :blocks

  def initialize(build)
    @build = build
    @blocks = {}
  end

  def block_by_path(path)
    path = @build.relative_path(path)
    @blocks[path] ||= Blocks::File.create!(name: path, build: @build)
  end

  def block_by_name(name)
    @blocks[name] ||= Blocks::Namespace.create!(name: name, build: @build)
  end

  def block_by_line(file, line)
    file.
      locations.
      reverse.
      find { |x| x.position.include?(line) }.
      try(:namespace)
  end
end
