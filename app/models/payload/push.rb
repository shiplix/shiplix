module Payload
  class Push < Base
    def branch
      data[:ref].sub('refs/heads/', '')
    end

    def repo_id
      data[:repository][:id]
    end

    def revision
      data[:head_commit][:id]
    end
  end
end
