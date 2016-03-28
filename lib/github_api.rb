require 'octokit'

class GithubApi
  CACHE_TTL = 1.day
  CALLBACK_ENDPOINT = "#{ENV.fetch('SHIPLIX_PROTOCOL', 'http')}://#{ENV.fetch('SHIPLIX_HOST')}/github_events"

  attr_reader :api

  def initialize(token)
    # TODO: remove after 20 april 2015
    Octokit.default_media_type = 'application/vnd.github.moondragon+json'

    @api = Octokit::Client.new(access_token: token, auto_paginate: true)
  end

  # Repo branches
  #
  # repo - String
  #
  # Returns Array of String
  def branches(repo)
    api.branches(repo).index_by(&:name)
  end

  # Repo default branch
  #
  # repo - String
  #
  # Returns String
  def default_branch(repo)
    api.repository(repo).default_branch
  end

  # Repo branch latest commit sha
  #
  # repo   - String
  # branch - String (optional)
  #
  # Returns String
  def recent_revision(repo, branch = nil)
    branch ||= default_branch(repo)
    api.branch(repo, branch).commit.sha
  end

  # Create repo hooks
  #
  # repo     - String
  # endpoint - String
  #
  # Yields hook_id - Integer
  def add_hooks(repo, endpoint)
    hook = api.create_hook(
      repo,
      'web',
      {
        url: endpoint,
        secret: ENV['GITHUB_SECRET_TOKEN']
      },
      {
        events: %w(push pull_request), active: true,
      }
    )

    yield hook.id
  rescue Octokit::UnprocessableEntity => error
    raise unless error.message.include? 'Hook already exists'
  end

  # Remove repo hooks
  #
  # repo    - String
  # hook_id - Integer
  def remove_hooks(repo, hook_id)
    api.remove_hook(repo, hook_id)
  end

  # All repos for access_token
  #
  # Returns Array of Hash
  def repos
    api.repos.map(&:to_hash)
  end

  def file_contents(repo, path, revision)
    with_cache('api/file_contents', repo, path, revision) do
      begin
        result = api.contents(repo, path: path, ref: revision)
        if result && result.content
          Base64.decode64(result.content).force_encoding("UTF-8")
        end
      rescue Octokit::NotFound
        ""
      rescue Octokit::Forbidden => exception
        if exception.errors.any? && exception.errors.first[:code] == "too_large"
          "File too large"
        else
          raise exception
        end
      end
    end
  end

  # Returns organizations where user is admin
  def own_organizations
    api.org_memberships.select { |org| org[:role] == "admin"}
  end

  private

  def with_cache(namespace, *args)
    cache_key = ActiveSupport::Cache.expand_cache_key(args, namespace)
    Rails.cache.fetch(cache_key, expires_in: CACHE_TTL) do
      yield
    end
  end
end
