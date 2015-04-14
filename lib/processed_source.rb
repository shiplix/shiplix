class ProcessedSource
  LINE_OFFSET = 1
  private_constant :LINE_OFFSET

  attr_reader :path, :ast, :raw_source

  def initialize(path)
    @path = path
    @raw_source = File.read(path)

    parse
  end

  # Public: returns LOC for source file or file part
  #
  # first_line - Fixnum, default nil
  # last_line - Fixnum, default nil
  #
  # Returns Integer
  def loc(first_line: nil, last_line: nil)
    if first_line.present? && last_line.present?
      source = lines[first_line - LINE_OFFSET..last_line - LINE_OFFSET]
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
