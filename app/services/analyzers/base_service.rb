module Analyzers
  class BaseService
    pattr_initialize :build

    attr_implement :call

    delegate :klass_by_name, :klass_by_line, :source_file_by_path, to: 'build.collections'
  end
end
