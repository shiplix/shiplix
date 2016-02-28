Rails.application.config.middleware.use OmniAuth::Builder do
  provider(
    :github,
    ENV['SHIPLIX_GITHUB_CLIENT_ID'],
    ENV['SHIPLIX_GITHUB_CLIENT_SECRET'],
    scope: 'user:email,repo'
  )
end
