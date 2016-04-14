module Analyzers
  class BaseService
    attr_initialize :build

    attr_implement :call

    private

    delegate :repo_config, to: :@build
    delegate :files, :find_file, :make_smell, to: "@build.collections"
  end
end
