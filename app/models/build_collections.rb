class BuildCollections
  attr_reader :build
  attr_reader :repo
  attr_reader :klasses
  attr_reader :source_files

  def initialize(build)
    @build = build
    @repo = build.branch.repo
    @klasses = {}.with_indifferent_access
    @source_files = {}.with_indifferent_access
  end

  def klass_by_name(name)
    return klasses[name] if klasses.key?(name)

    klass = Klass.
      where(repo_id: repo.id).
      find_or_create_by!(name: name)

    klass.metric ||= klass.metrics.build(build_id: build.id)
    klasses[name] = klass
  end

  def klass_by_line(source_file, line)
    klass = source_file.klass_source_files.
      where(build_id: build.id).
      where('line <= ? and line_end >= ?', line, line).
      order(:line).
      first.
      try(:klass)

    klass_by_name(klass.name) if klass
  end

  def source_file_by_path(path)
    path = build.relative_path(path)
    return source_files[path] if source_files.key?(path)

    source_file = SourceFile.
      where(repo_id: repo.id).
      find_or_create_by!(path: build.relative_path(path))

    source_file.metric = source_file.metrics.build(build_id: build.id)
    source_files[path] = source_file
  end

  def save
    [source_files, klasses].each { |x| save_collection(x) }
  end

  private

  def save_collection(collection)
    collection.each do |_, record|
      record.save!
    end
  end
end
