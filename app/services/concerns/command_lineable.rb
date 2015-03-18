module CommandLineable
  extend ActiveSupport::Concern

  included do
    alias_method_chain :initialize, :cmd
  end

  def initialize_with_cmd(*args)
    initialize_without_cmd(*args)
    Cocaine::CommandLine.logger = Logger.new(STDOUT)
  end

  protected

  def cmd(*args)
    Cocaine::CommandLine.new(*args)
  end
end
