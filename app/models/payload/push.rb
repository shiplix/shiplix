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

    def revision=(value)
      data[:head_commit][:id] = value
    end

    def prev_revision
      data[:before]
    end

    def prev_revision=(value)
      data[:before] = value
    end

    def timestamp
      DateTime.parse(data[:head_commit][:timestamp]).utc
    end
  end
end
