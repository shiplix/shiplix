class SmellsDecorator < Draper::CollectionDecorator
  def source_grouped
    @source_grouped ||= each_with_object({}) do |smell, memo|
      smell.locations.each do |location|
        key = location.source_file.path
        memo[key] ||= {}
        (memo[key][smell.type] ||= []) << {
          name: smell.name,
          message: smell.message,
          icon: smell.class.icon,
          line: location.line,
          num_lines: location.num_lines
        }
      end
    end
  end
end
