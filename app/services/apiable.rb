module Apiable
  def api
    @api ||= Octokit::Client.new(access_token: user.access_token, auto_paginate: true)
  end
end
