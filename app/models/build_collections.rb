class BuildCollections
  attr_reader :build
  attr_reader :klasses
  attr_reader :source_files

  def initialize(build)
    @build = build
    @klasses = {}
    @source_files = {}
  end

  def klass_by_name(name)
    klasses[name] ||= Klass.
      where(build: build).
      find_or_create_by!(name: name)
  end

  def klass_by_line(source_file, line)
    klass = source_file.klass_source_files.
      where('line <= ? and line_end >= ?', line, line).
      order(:line).
      first.
      try(:klass)

    klasses[klass.name] ||= klass if klass
  end

  def source_file_by_path(path)
    source_files[path] ||= SourceFile.
      where(build: build).
      find_or_create_by!(path: build.relative_path(path))
  end

  def save
    save_collection(klasses) if klasses.present?
    save_collection(source_files) if klasses.present?
  end

  private

  def save_collection(collection)
    collection.each do |_, record|
      record.save! if record.changed?
    end
  end
end
