class ProcessedSource
  attr_reader :path, :ast, :raw_source

  def initialize(path)
    @path = path
    @raw_source = File.read(path)

    parse
  end

  # Public: returns LOC for source file or file part
  #
  # range - Range first..end lines, default nil
  #
  # Returns Integer
  def loc(range = nil)
    if range.present?
      source = lines[(range.first - LINE_OFFSET..range.last - LINE_OFFSET)]
    else
      source = lines
    end

    source.reject do |line|
      line.strip.blank? || comment_line?(line)
    end.size
  end

  def lines
    @lines ||= raw_source.lines.map(&:chomp)
  end

  private

  def comment_line?(line)
    line =~ /^\s*#/
  end

  LINE_OFFSET = 1

  def parser
    builder = Shiplix::Builder.new
    Parser::CurrentRuby.new(builder)
  end

  def parse
    buffer = Parser::Source::Buffer.new(path)
    buffer.raw_source = @raw_source

    @ast = parser.parse(buffer)
  end
end
