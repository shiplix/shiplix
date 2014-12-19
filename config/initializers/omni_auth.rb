Rails.application.config.middleware.use OmniAuth::Builder do
  provider(
    :github,
    ENV.fetch('GITHUB_CLIENT_ID', '0aa9e1f5b212620e175b'),
    ENV.fetch('GITHUB_CLIENT_SECRET', '53659cce362ad897c00e34430350d172910a75ad'),
    scope: 'user:email,repo'
  )
end
