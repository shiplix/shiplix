Rails.application.config.middleware.use OmniAuth::Builder do
  provider(
    :github,
    ENV.fetch('SHIPLIX_GITHUB_CLIENT_ID'),
    ENV.fetch('SHIPLIX_GITHUB_CLIENT_SECRET'),
    scope: 'user:email,repo'
  )
end
