module Analyzers
  class BaseService
    pattr_initialize :build
    attr_implement :call

    private

    def klass_by_name(name)
      @klasses ||= {}
      @klasses[name] ||= build.klasses.find_or_create_by!(name: name)
    end

    # Private: find or create SourceFile for build by path
    # if save: false SourceFile not save in database
    #
    # path - String, absolute path to file
    #
    # Options
    #   save - save SourceFile to database (default: true)
    #
    # Returns SourceFile
    def source_file_by_path(path, save: true)
      @source_files ||= {}

      @source_files[path.freeze] ||= if save
                                build.source_files.find_or_create_by!(path: relative_path(path))
                              else
                                build.source_files.build(path: relative_path(path))
                              end
    end

    def relative_path(path)
      @revision_path ||= build.revision_path.to_s + '/'
      path.sub(@revision_path, '')
    end
  end
end
