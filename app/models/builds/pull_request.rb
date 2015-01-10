module Builds
  class PullRequest < Build
    validates :pull_request_number, presence: true
  end
end
