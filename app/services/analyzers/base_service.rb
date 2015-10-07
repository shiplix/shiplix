module Analyzers
  class BaseService
    pattr_initialize :build

    attr_implement :call

    private

    delegate :block_by_name, :block_by_path, :block_by_line, to: 'build.collections'

    def increment_smells(block)
      block.increment(:smells_count)
      build.increment(:smells_count)
    end
  end
end
