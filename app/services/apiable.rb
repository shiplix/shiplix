require 'github_api'

module Apiable
  def api
    @api ||= GithubApi.new(user.access_token)
  end
end
