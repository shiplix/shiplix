class BuildCollections
  attr_reader :files

  RawFile = Struct.new(:path, :smells, :pain, :metrics, :grade)

  RawSmell = Struct.new(:file, :position, :analyzer, :check_name, :message, :pain, :data) do
    def fingerprint
      params = [file.path, position, analyzer, check_name, pain, message, data]
      Digest::MD5.hexdigest(params.join(":"))
    end
  end

  def initialize(build)
    @build = build
    @files = {}
  end

  def find_file(path)
    path = @build.relative_path(path)
    @files[path] ||= RawFile.new(path).tap do |file|
      file.smells = []
      file.metrics = {}
      file.pain = 0
      file.grade = "A".freeze
    end
  end

  # Build a code raw smell
  #
  # file     - BuildCollections::RawFile
  # options  - Hash
  #            :analyzer   - String (required)
  #            :check_name - String (required)
  #            :line       - Integer (default: 0)
  #            :position   - Range
  #            :message    - String
  #            :pain       - Integer (default: 0)
  #            :data       - Hash
  #
  # Returns BuildCollections::RawSmell
  def make_smell(file, options)
    pain = options.fetch(:pain, 0)

    smell = RawSmell.new(file)
    smell.position = options[:line] || options[:position] || 0
    smell.analyzer = options.fetch(:analyzer)
    smell.check_name = options.fetch(:check_name)
    smell.message = options[:message]
    smell.pain = pain
    smell.data = options.fetch(:data, {})

    (file.smells ||= []) << smell
    file.pain += pain if pain > 0

    smell
  end
end
