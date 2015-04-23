class ApplicationService
  protected

  def api
    @api ||= GithubApi.new(user.access_token)
  end
end
