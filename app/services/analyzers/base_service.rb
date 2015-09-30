module Analyzers
  class BaseService
    pattr_initialize :build

    attr_implement :call

    delegate :klass_by_name, :klass_by_line, :source_file_by_path, to: 'build.collections'

    protected

    def create_smell(smell_class, klass_or_file, attrs = {})
      attrs[:build] ||= build
      attrs[:subject] ||= klass_or_file
      smell_class.create!(attrs)
    end
  end
end
