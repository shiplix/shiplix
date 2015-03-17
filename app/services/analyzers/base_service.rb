module Analyzers
  class BaseService
    pattr_initialize :build

    attr_implement :call

    delegate :klass_by_name, :klass_by_line, :source_file_by_path, to: 'build.collections'

    protected

    def create_smell(type_class, subject, params = {})
      smell = type_class.create!(params.merge(build: build, subject: subject))
      subject.metric.increment(:smells_count)
      build.increment(:smells_count)

      smell
    end
  end
end
