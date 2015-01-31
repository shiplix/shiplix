module Analyzers
  class BaseService
    pattr_initialize :build
    attr_implement :call

    private

    def klass_by_name(name)
      @klasses ||= {}
      @klasses[name] ||= build.klasses.find_or_create_by!(name: name)
    end

    def source_file_by_path(path)
      @source_files ||= {}
      @source_files[path] ||= build.source_files.find_or_create_by!(path: relative_path(path))
    end

    def relative_path(path)
      @revision_path ||= build.locator.revision_path.to_s + '/'
      path.sub(@revision_path, '')
    end
  end
end
