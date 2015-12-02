class SmellsDecorator < Draper::CollectionDecorator
  def source_grouped
    @source_grouped ||= each_with_object({}) do |smell, memo|
      file_name = smell.file.name

      memo[file_name] ||= {}

      (memo[file_name][smell.type] ||= []) << {
        name: smell.name,
        message: smell.data['message'],
        icon: smell.class.icon,
        line: smell.position.first,
        num_lines: smell.position.count
      }
    end
  end
end
