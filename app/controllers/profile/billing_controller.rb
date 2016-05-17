module Profile
  class BillingController < ::ApplicationController
    def index
      # TODO: fix n+1 for subscription.plan
      @owners = OwnersFinder.new(current_user).call
    end
  end
end
