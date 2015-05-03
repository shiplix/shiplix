require 'resque-retry'
require 'octokit'

module Retryable
  extend Resque::Plugins::Retry

  @retry_limit = 3
  @retry_delay = 120
  @fatal_exceptions = [Octokit::Unauthorized]
end
