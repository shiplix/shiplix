SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    primary.item(:repos,
                 'Go to dashboard',
                 repos_url,
                 html: {icon: 'fa-desktop'})

    primary.item(:billing,
                 'Billing',
                 profile_billing_index_path,
                 highlights_on: :subpath,
                 html: {icon: 'fa-file-text-o'})
  end
end
