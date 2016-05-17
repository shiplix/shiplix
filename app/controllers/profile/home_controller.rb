module Profile
  class HomeController < ::ApplicationController
    def index
      # NOTE: in feature we should implement other settings
      # for profile e.g notifications.
      #
      # Now this redirect to choose plan ;)
      redirect_to profile_billing_index_url
    end
  end
end
