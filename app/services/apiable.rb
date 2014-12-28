module Apiable
  def api
    @api ||= Octokit::Client.new(access_token: github_token)
  end
end
