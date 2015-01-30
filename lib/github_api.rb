require 'octokit'

class GithubApi
  attr_reader :api

  def initialize(token)
    @api ||= Octokit::Client.new(access_token: token, auto_paginate: true)
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
      {url: endpoint},
      {events: %w(push pull_request), active: true}
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
    user_repos + org_repos
  end

  # Add deploy public rsa key
  #
  # repo - String
  # key  - String
  #
  # Yields deploy_key_id - Integer
  def add_deploy_key(repo, key)
    deploy_key = api.add_deploy_key(repo, deploy_key_name, key)

    yield deploy_key.id
  rescue Octokit::UnprocessableEntity => error
    raise unless error.message.include? 'Key has already been taken'
  end

  # Remove deploy public rsa key
  #
  # repo - String
  #
  # Returns boolean
  def remove_deploy_key(repo, deploy_key_id)
    api.remove_deploy_key(repo, deploy_key_id)
  end

  private

  def deploy_key_name
    name = %w(Shiplix)

    if Rails.env.staging?
      name << 'staging'
    elsif !Rails.env.production?
      name << Rails.env.to_s
    end

    name.join(' - ')
  end

  def user_repos
    authorized_repos(api.repos)
  end

  def org_repos
    repos = api.orgs.flat_map do |org|
      api.org_repos(org[:login])
    end

    authorized_repos(repos)
  end

  def authorized_repos(repos)
    repos.select { |repo| repo.permissions.admin }.map(&:to_hash)
  end
end
