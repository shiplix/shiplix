class BuildCollections
  attr_reader :blocks

  def initialize(build)
    @build = build
    @blocks = ActiveSupport::HashWithIndifferentAccess.new
  end

  def block_by_path(path)
    path = @build.relative_path(path)
    @blocks[path] ||= Blocks::File.create!(name: path, build: @build)
  end

  def block_by_name(name)
    @blocks[name] ||= Blocks::Namespace.create!(name: name, build: @build)
  end

  def block_by_line(file, line)
    klass = file.
              locations.
              reverse.
              find { |x| x.position.include?(line) }.
              try(:namespace)

    @blocks[klass.name] ||= klass if klass.present?
  end
end
